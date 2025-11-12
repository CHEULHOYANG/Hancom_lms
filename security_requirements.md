# LMS 보안 요구사항 및 구현 가이드

## 1. 인증/인가 보안 (OWASP A01: Broken Access Control)

### 위협
- 세션 하이재킹, 권한 우회, 수직/수평 권한 상승

### 권고사항
- JWT 토큰 기반 인증 + Refresh Token 전략
- 역할 기반 접근 제어 (RBAC)
- 비밀번호 강화 (Argon2 해싱)

### 구현 예시
```python
# backend/apps/authentication/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models
import argon2
from datetime import datetime, timedelta
import jwt
from django.conf import settings

class User(AbstractUser):
    ROLE_CHOICES = [
        ('student', 'Student'),
        ('instructor', 'Instructor'), 
        ('admin', 'Admin'),
    ]
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='student')
    phone = models.CharField(max_length=20, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    failed_login_attempts = models.IntegerField(default=0)
    account_locked_until = models.DateTimeField(null=True, blank=True)
    
    def set_password(self, raw_password):
        """Argon2 password hashing"""
        ph = argon2.PasswordHasher(
            time_cost=3,    # iterations
            memory_cost=65536,  # memory in KB
            parallelism=1,
            hash_len=32,
            salt_len=16
        )
        self.password = ph.hash(raw_password)
    
    def check_password(self, raw_password):
        """Verify password with Argon2"""
        try:
            ph = argon2.PasswordHasher()
            ph.verify(self.password, raw_password)
            return True
        except argon2.exceptions.VerifyMismatchError:
            return False
    
    def generate_jwt_tokens(self):
        """Generate access and refresh tokens"""
        access_payload = {
            'user_id': self.id,
            'username': self.username,
            'role': self.role,
            'exp': datetime.utcnow() + timedelta(minutes=15),  # Short TTL
            'iat': datetime.utcnow(),
            'type': 'access'
        }
        
        refresh_payload = {
            'user_id': self.id,
            'exp': datetime.utcnow() + timedelta(days=7),
            'iat': datetime.utcnow(),
            'type': 'refresh'
        }
        
        access_token = jwt.encode(access_payload, settings.SECRET_KEY, algorithm='HS256')
        refresh_token = jwt.encode(refresh_payload, settings.SECRET_KEY, algorithm='HS256')
        
        # Store refresh token in Redis for blacklist capability
        from django.core.cache import cache
        cache.set(f"refresh_token:{self.id}:{refresh_token}", True, timeout=7*24*3600)
        
        return access_token, refresh_token

# JWT Authentication Middleware
from django.http import JsonResponse
import jwt
from django.conf import settings
from django.contrib.auth import get_user_model

class JWTAuthenticationMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        token = self.get_token_from_request(request)
        
        if token:
            try:
                payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
                if payload.get('type') != 'access':
                    raise jwt.InvalidTokenError("Invalid token type")
                
                User = get_user_model()
                user = User.objects.get(id=payload['user_id'])
                request.user = user
                
            except jwt.ExpiredSignatureError:
                return JsonResponse({'error': 'Token expired'}, status=401)
            except jwt.InvalidTokenError:
                return JsonResponse({'error': 'Invalid token'}, status=401)
            except User.DoesNotExist:
                return JsonResponse({'error': 'User not found'}, status=401)

        response = self.get_response(request)
        return response
    
    def get_token_from_request(self, request):
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        if auth_header and auth_header.startswith('Bearer '):
            return auth_header.split(' ')[1]
        return None

# Role-based permission decorator
from functools import wraps
from django.http import JsonResponse

def require_role(allowed_roles):
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            if not hasattr(request, 'user') or not request.user.is_authenticated:
                return JsonResponse({'error': 'Authentication required'}, status=401)
            
            if request.user.role not in allowed_roles:
                return JsonResponse({'error': 'Insufficient permissions'}, status=403)
            
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator
```

### 검증 방법
```python
# tests/test_authentication.py
import pytest
from django.test import TestCase, Client
from django.contrib.auth import get_user_model
import jwt
from datetime import datetime, timedelta

class AuthenticationSecurityTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.User = get_user_model()
        
    def test_password_hashing_argon2(self):
        """Test Argon2 password hashing"""
        user = self.User.objects.create_user(
            username='testuser',
            password='StrongPassword123!'
        )
        # Password should be hashed with Argon2
        self.assertTrue(user.password.startswith('$argon2'))
        self.assertTrue(user.check_password('StrongPassword123!'))
        self.assertFalse(user.check_password('wrongpassword'))
    
    def test_jwt_token_expiration(self):
        """Test JWT token expiration"""
        user = self.User.objects.create_user(username='testuser', password='pass')
        access_token, refresh_token = user.generate_jwt_tokens()
        
        # Verify token structure
        payload = jwt.decode(access_token, settings.SECRET_KEY, algorithms=['HS256'])
        self.assertEqual(payload['type'], 'access')
        self.assertEqual(payload['user_id'], user.id)
        
    def test_role_based_access_control(self):
        """Test RBAC implementation"""
        student = self.User.objects.create_user(
            username='student', password='pass', role='student'
        )
        admin = self.User.objects.create_user(
            username='admin', password='pass', role='admin'
        )
        
        # Student should not access admin endpoints
        # (Test with actual view implementation)
```

## 2. 세션/쿠키 보안

### 구현 예시
```python
# settings/production.py
SESSION_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = 'Strict'
SESSION_COOKIE_AGE = 3600  # 1 hour
CSRF_COOKIE_SECURE = True
CSRF_COOKIE_HTTPONLY = True
CSRF_COOKIE_SAMESITE = 'Strict'

# Session regeneration on login
from django.contrib.auth import login
from django.contrib.sessions.models import Session

def secure_login(request, user):
    """Secure login with session regeneration"""
    # Delete old session
    if hasattr(request, 'session'):
        request.session.flush()
    
    # Create new session
    login(request, user)
    request.session.cycle_key()
    
    # Reset failed login attempts
    user.failed_login_attempts = 0
    user.account_locked_until = None
    user.save()
```

## 3. 입력 검증 및 출력 인코딩 (OWASP A03: Injection)

### 구현 예시
```python
# backend/apps/common/validators.py
from django.core.exceptions import ValidationError
import re
import bleach

class SecurityValidator:
    @staticmethod
    def validate_username(username):
        """Validate username format"""
        if not re.match(r'^[a-zA-Z0-9_]{3,30}$', username):
            raise ValidationError('Username must be 3-30 chars, alphanumeric and underscore only')
        
        # Check for common attack patterns
        dangerous_patterns = ['<script', 'javascript:', 'onload=', 'onerror=']
        username_lower = username.lower()
        for pattern in dangerous_patterns:
            if pattern in username_lower:
                raise ValidationError('Username contains invalid characters')
    
    @staticmethod
    def sanitize_html_content(content):
        """Sanitize HTML content to prevent XSS"""
        allowed_tags = ['p', 'br', 'strong', 'em', 'u', 'ol', 'ul', 'li', 'a']
        allowed_attributes = {'a': ['href', 'title']}
        
        return bleach.clean(
            content,
            tags=allowed_tags,
            attributes=allowed_attributes,
            strip=True
        )
    
    @staticmethod
    def validate_file_upload(uploaded_file):
        """Validate file uploads"""
        # Size limit (10MB)
        max_size = 10 * 1024 * 1024
        if uploaded_file.size > max_size:
            raise ValidationError('File size exceeds 10MB limit')
        
        # Allowed extensions
        allowed_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.pdf', '.doc', '.docx']
        file_extension = uploaded_file.name.lower().split('.')[-1]
        if f'.{file_extension}' not in allowed_extensions:
            raise ValidationError('File type not allowed')
        
        # MIME type validation
        import magic
        mime = magic.from_buffer(uploaded_file.read(), mime=True)
        uploaded_file.seek(0)  # Reset file pointer
        
        allowed_mimes = [
            'image/jpeg', 'image/png', 'image/gif',
            'application/pdf', 'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        ]
        
        if mime not in allowed_mimes:
            raise ValidationError('File content type not allowed')

# Serializers with validation
from rest_framework import serializers
from .validators import SecurityValidator

class CourseSerializer(serializers.ModelSerializer):
    def validate_title(self, value):
        # Length validation
        if len(value) < 3 or len(value) > 255:
            raise serializers.ValidationError('Title must be 3-255 characters')
        
        # HTML sanitization
        return SecurityValidator.sanitize_html_content(value)
    
    def validate_description(self, value):
        # Sanitize HTML content
        return SecurityValidator.sanitize_html_content(value)
```

## 4. SQL Injection 방지

### 구현 예시
```python
# Always use Django ORM instead of raw SQL
from django.db import models
from django.db.models import Q

class CourseQuerySet(models.QuerySet):
    def search(self, query):
        """Safe search implementation"""
        if not query:
            return self.none()
        
        # Use parameterized queries through ORM
        return self.filter(
            Q(title__icontains=query) | 
            Q(description__icontains=query)
        )
    
    def filter_by_user_access(self, user):
        """Filter courses by user access rights"""
        if user.role == 'admin':
            return self.all()
        elif user.role == 'instructor':
            return self.filter(instructor=user)
        else:
            return self.filter(is_published=True)

# If raw SQL is absolutely necessary, use parameters
from django.db import connection

def get_user_stats(user_id):
    """Example of safe raw SQL usage"""
    with connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT COUNT(*) as course_count, 
                   AVG(progress) as avg_progress
            FROM enrollments 
            WHERE user_id = %s AND status = 'active'
            """,
            [user_id]  # Parameterized query
        )
        return cursor.fetchone()
```

## 5. CSRF 방지

### 구현 예시
```python
# settings/base.py
CSRF_USE_SESSIONS = True
CSRF_COOKIE_HTTPONLY = True
CSRF_TRUSTED_ORIGINS = ['https://lms.example.com']

# API views with CSRF protection
from django.views.decorators.csrf import csrf_protect
from django.utils.decorators import method_decorator
from rest_framework.views import APIView

@method_decorator(csrf_protect, name='dispatch')
class CourseEnrollmentView(APIView):
    def post(self, request, course_id):
        # CSRF token automatically validated by decorator
        pass

# Frontend CSRF token handling
// React component
import { getCsrfToken } from '../utils/csrf';

const EnrollmentForm = () => {
    const handleSubmit = async (formData) => {
        const csrfToken = await getCsrfToken();
        
        const response = await fetch('/api/enrollments/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': csrfToken,
            },
            body: JSON.stringify(formData),
        });
    };
};
```

## 6. 파일 업로드 보안

### 구현 예시
```python
# backend/apps/common/file_handlers.py
import os
import uuid
import subprocess
from django.core.files.storage import default_storage
from django.conf import settings

class SecureFileHandler:
    def __init__(self):
        self.upload_path = 'uploads/'
        self.max_file_size = 10 * 1024 * 1024  # 10MB
        
    def handle_upload(self, uploaded_file, upload_type='general'):
        """Secure file upload handling"""
        # Validate file
        self._validate_file(uploaded_file)
        
        # Generate secure filename
        file_extension = self._get_safe_extension(uploaded_file.name)
        secure_filename = f"{uuid.uuid4()}{file_extension}"
        
        # Create upload directory
        upload_dir = os.path.join(self.upload_path, upload_type)
        full_path = os.path.join(upload_dir, secure_filename)
        
        # Save file
        saved_path = default_storage.save(full_path, uploaded_file)
        
        # Remove execute permissions
        actual_path = default_storage.path(saved_path)
        os.chmod(actual_path, 0o644)
        
        # Virus scan (if ClamAV is available)
        if self._is_clamav_available():
            self._scan_file(actual_path)
        
        return saved_path
    
    def _validate_file(self, uploaded_file):
        """Comprehensive file validation"""
        # Size check
        if uploaded_file.size > self.max_file_size:
            raise ValueError('File too large')
        
        # Extension whitelist
        allowed_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.pdf', '.doc', '.docx'}
        file_ext = self._get_safe_extension(uploaded_file.name)
        if file_ext not in allowed_extensions:
            raise ValueError('File type not allowed')
        
        # Magic number verification
        self._verify_file_type(uploaded_file)
    
    def _verify_file_type(self, uploaded_file):
        """Verify file type by magic numbers"""
        import magic
        mime = magic.from_buffer(uploaded_file.read(1024), mime=True)
        uploaded_file.seek(0)
        
        allowed_mimes = {
            'image/jpeg', 'image/png', 'image/gif',
            'application/pdf', 'application/msword'
        }
        
        if mime not in allowed_mimes:
            raise ValueError('File content type mismatch')
    
    def _scan_file(self, file_path):
        """Virus scan with ClamAV"""
        try:
            result = subprocess.run(
                ['clamscan', '--no-summary', file_path],
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode != 0:
                os.remove(file_path)
                raise ValueError('File failed virus scan')
        except subprocess.TimeoutExpired:
            raise ValueError('Virus scan timeout')
```

## 7. 보안 헤더 설정

### 구현 예시
```python
# settings/production.py
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
X_FRAME_OPTIONS = 'DENY'

# Custom middleware for additional headers
class SecurityHeadersMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        
        # Content Security Policy
        csp = (
            "default-src 'self'; "
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; "
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; "
            "font-src 'self' https://fonts.gstatic.com; "
            "img-src 'self' data: https:; "
            "media-src 'self' https:; "
            "frame-src 'none'; "
            "object-src 'none';"
        )
        response['Content-Security-Policy'] = csp
        
        # Additional headers
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        response['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'
        
        return response
```

## 8. 로깅 및 모니터링

### 구현 예시
```python
# settings/logging.py
import logging
import json

class SecurityEventLogger:
    def __init__(self):
        self.logger = logging.getLogger('security')
    
    def log_login_attempt(self, username, ip_address, success=True, reason=None):
        """Log login attempts"""
        event = {
            'event_type': 'login_attempt',
            'username': username,
            'ip_address': ip_address,
            'success': success,
            'timestamp': datetime.utcnow().isoformat(),
            'reason': reason
        }
        
        if success:
            self.logger.info(f"Successful login: {json.dumps(event)}")
        else:
            self.logger.warning(f"Failed login: {json.dumps(event)}")
    
    def log_permission_violation(self, user, requested_resource, ip_address):
        """Log permission violations"""
        event = {
            'event_type': 'permission_violation',
            'user_id': user.id if user.is_authenticated else None,
            'username': user.username if user.is_authenticated else 'anonymous',
            'requested_resource': requested_resource,
            'ip_address': ip_address,
            'timestamp': datetime.utcnow().isoformat()
        }
        
        self.logger.error(f"Permission violation: {json.dumps(event)}")

# Logging configuration
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'json': {
            'format': '{levelname} {asctime} {module} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'security_file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': 'logs/security.log',
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
            'formatter': 'json',
        },
    },
    'loggers': {
        'security': {
            'handlers': ['security_file'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}
```

## 보안 체크리스트

### 개발자용 체크리스트
- [ ] 모든 사용자 입력에 서버사이드 검증 적용
- [ ] SQL 쿼리는 ORM 사용, 불가피한 경우 parameterized query 사용
- [ ] 파일 업로드 시 확장자, MIME 타입, 크기 검증
- [ ] JWT 토큰에 짧은 TTL 설정 및 Refresh Token 전략 구현
- [ ] 모든 API 엔드포인트에 적절한 권한 검사 적용
- [ ] 민감한 정보는 환경변수로 관리
- [ ] HTTPS 강제 및 보안 헤더 설정
- [ ] 에러 메시지에서 시스템 정보 노출 방지

### 운영자용 체크리스트  
- [ ] 데이터베이스 접근은 최소 권한 계정 사용
- [ ] 방화벽에서 필요한 포트만 개방
- [ ] 정기적인 보안 패치 적용
- [ ] 로그 모니터링 및 이상 패턴 감지 시스템 구축
- [ ] 백업 데이터 암호화
- [ ] SSL/TLS 인증서 자동 갱신 설정
- [ ] DDoS 방어 시스템 구축
- [ ] 침입 탐지 시스템(IDS) 운영