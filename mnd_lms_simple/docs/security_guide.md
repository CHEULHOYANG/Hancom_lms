# MND LMS 보안 적용 내용 및 가이드

## ?? 보안 개요

### 1.1 보안 목표
- **기밀성(Confidentiality)**: 개인정보 및 민감정보 보호
- **무결성(Integrity)**: 데이터의 정확성 및 완전성 보장
- **가용성(Availability)**: 서비스의 지속적인 접근 가능성
- **인증(Authentication)**: 사용자 신원 확인
- **권한부여(Authorization)**: 적절한 접근 권한 제어

### 1.2 보안 표준 준수
- **개인정보보호법**: 개인정보 처리 기준 준수
- **정보보호 관리체계(ISMS)**: 정보보호 관리 기준
- **국가 사이버보안 기본법**: 국가기관 보안 기준
- **OWASP Top 10**: 웹 애플리케이션 보안 취약점 대응

## ? 적용된 보안 기능

### 2.1 인증 보안

#### 비밀번호 보안
```python
# Django PBKDF2 해싱 사용
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 8,
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# 커스텀 비밀번호 검증
class CustomPasswordValidator:
    def validate(self, password, user=None):
        if not re.search(r'[A-Z]', password):
            raise ValidationError('비밀번호는 대문자를 포함해야 합니다.')
        if not re.search(r'[a-z]', password):
            raise ValidationError('비밀번호는 소문자를 포함해야 합니다.')
        if not re.search(r'[0-9]', password):
            raise ValidationError('비밀번호는 숫자를 포함해야 합니다.')
        if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
            raise ValidationError('비밀번호는 특수문자를 포함해야 합니다.')
```

#### 세션 보안
```python
# 세션 보안 설정
SESSION_COOKIE_SECURE = True  # HTTPS에서만 쿠키 전송
SESSION_COOKIE_HTTPONLY = True  # JavaScript 접근 차단
SESSION_COOKIE_SAMESITE = 'Strict'  # CSRF 공격 방지
SESSION_EXPIRE_AT_BROWSER_CLOSE = True  # 브라우저 닫으면 세션 만료
SESSION_COOKIE_AGE = 3600  # 1시간 후 세션 만료

# 세션 하이재킹 방지
def login_required_secure(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')
        
        # IP 주소 검증
        current_ip = get_client_ip(request)
        session_ip = request.session.get('ip_address')
        
        if session_ip and session_ip != current_ip:
            logout(request)
            messages.error(request, '보안상의 이유로 로그아웃되었습니다.')
            return redirect('login')
        
        request.session['ip_address'] = current_ip
        return view_func(request, *args, **kwargs)
    return wrapper
```

### 2.2 입력 데이터 보안

#### SQL 인젝션 방지
```python
# Django ORM 사용으로 SQL 인젝션 방지
def get_user_courses(user_id):
    # 안전한 방법 - Django ORM 사용
    return Course.objects.filter(
        enrollments__student_id=user_id,
        status='published'
    )

# 원시 쿼리 사용 시 매개변수 바인딩
def get_course_statistics(course_id):
    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT COUNT(*) FROM enrollments WHERE course_id = %s",
            [course_id]  # 매개변수 바인딩으로 안전하게 처리
        )
        return cursor.fetchone()[0]
```

#### XSS(Cross-Site Scripting) 방지
```python
# 템플릿에서 자동 이스케이프
# Django 템플릿은 기본적으로 HTML 이스케이프 적용
{{ user.username }}  # 자동으로 HTML 이스케이프됨

# 커스텀 필터로 추가 보안
from django.utils.html import format_html, escape

def safe_markdown(value):
    # Markdown을 안전하게 HTML로 변환
    import markdown
    from markdown.extensions import codehilite
    
    md = markdown.Markdown(
        extensions=['codehilite', 'fenced_code'],
        extension_configs={
            'codehilite': {'css_class': 'highlight'}
        }
    )
    return format_html(md.convert(escape(value)))
```

#### CSRF(Cross-Site Request Forgery) 방지
```html
<!-- 모든 POST 폼에 CSRF 토큰 포함 -->
<form method="post">
    {% csrf_token %}
    <input type="text" name="username" required>
    <input type="password" name="password" required>
    <button type="submit">로그인</button>
</form>
```

```python
# CSRF 설정
CSRF_COOKIE_SECURE = True  # HTTPS에서만 CSRF 쿠키 전송
CSRF_COOKIE_HTTPONLY = True  # JavaScript 접근 차단
CSRF_USE_SESSIONS = True  # 세션에서 CSRF 토큰 관리
```

### 2.3 데이터 보호

#### 개인정보 마스킹
```python
class CustomUser(AbstractUser):
    def get_masked_email(self):
        """이메일 마스킹 처리"""
        if not self.email:
            return ''
        
        local, domain = self.email.split('@')
        if len(local) <= 2:
            return self.email
        
        masked_local = local[:2] + '*' * (len(local) - 2)
        return f"{masked_local}@{domain}"
    
    def get_masked_phone(self):
        """전화번호 마스킹 처리"""
        if not self.phone:
            return ''
        
        # 010-1234-5678 -> 010-****-5678
        parts = self.phone.split('-')
        if len(parts) == 3:
            return f"{parts[0]}-****-{parts[2]}"
        
        return self.phone[:3] + '*' * (len(self.phone) - 6) + self.phone[-3:]
    
    def get_masked_name(self):
        """이름 마스킹 처리"""
        if not self.real_name:
            return ''
        
        if len(self.real_name) <= 2:
            return self.real_name[0] + '*'
        
        return self.real_name[0] + '*' * (len(self.real_name) - 2) + self.real_name[-1]
```

#### 민감정보 암호화
```python
from cryptography.fernet import Fernet
from django.conf import settings

class EncryptedField:
    def __init__(self):
        self.cipher = Fernet(settings.ENCRYPTION_KEY.encode())
    
    def encrypt(self, value):
        """데이터 암호화"""
        if not value:
            return value
        return self.cipher.encrypt(value.encode()).decode()
    
    def decrypt(self, value):
        """데이터 복호화"""
        if not value:
            return value
        return self.cipher.decrypt(value.encode()).decode()

# 민감정보 필드에 암호화 적용
class SecureUserProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    encrypted_ssn = models.TextField(blank=True)  # 주민등록번호 암호화 저장
    encrypted_phone = models.TextField(blank=True)  # 전화번호 암호화 저장
    
    def save(self, *args, **kwargs):
        if self.ssn:
            encryptor = EncryptedField()
            self.encrypted_ssn = encryptor.encrypt(self.ssn)
        super().save(*args, **kwargs)
```

### 2.4 접근 제어

#### 역할 기반 접근 제어 (RBAC)
```python
from django.contrib.auth.decorators import user_passes_test
from django.core.exceptions import PermissionDenied

def is_admin(user):
    """관리자 권한 확인"""
    return user.is_authenticated and user.is_staff

def is_instructor(user):
    """강사 권한 확인"""
    return user.is_authenticated and hasattr(user, 'instructor_profile')

def require_permission(permission):
    """특정 권한 요구 데코레이터"""
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            if not request.user.has_perm(permission):
                raise PermissionDenied("접근 권한이 없습니다.")
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator

# 사용 예시
@require_permission('mnd_lms_simple.change_course')
def edit_course(request, course_id):
    # 강의 수정 권한이 있는 사용자만 접근 가능
    pass
```

#### API 접근 제어
```python
from rest_framework.permissions import BasePermission

class IsAdminOrReadOnly(BasePermission):
    """관리자는 모든 작업, 일반 사용자는 읽기만 가능"""
    
    def has_permission(self, request, view):
        if request.method in ['GET', 'HEAD', 'OPTIONS']:
            return request.user.is_authenticated
        return request.user.is_staff

class IsOwnerOrAdmin(BasePermission):
    """소유자 또는 관리자만 접근 가능"""
    
    def has_object_permission(self, request, view, obj):
        if request.user.is_staff:
            return True
        return obj.owner == request.user
```

### 2.5 로깅 및 모니터링

#### 보안 이벤트 로깅
```python
import logging
from datetime import datetime

security_logger = logging.getLogger('security')

class SecurityMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # 로그인 시도 로깅
        if request.path == '/login/' and request.method == 'POST':
            username = request.POST.get('username', 'Unknown')
            ip_address = self.get_client_ip(request)
            security_logger.info(f"Login attempt: {username} from {ip_address}")

        response = self.get_response(request)

        # 실패한 로그인 시도 로깅
        if request.path == '/login/' and response.status_code == 200:
            if 'error' in response.content.decode():
                security_logger.warning(f"Failed login: {username} from {ip_address}")

        return response

    def get_client_ip(self, request):
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip
```

#### 이상 행동 탐지
```python
from django.core.cache import cache
from django.http import HttpResponseTooManyRequests

class RateLimitMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if self.is_rate_limited(request):
            security_logger.warning(f"Rate limit exceeded: {self.get_client_ip(request)}")
            return HttpResponseTooManyRequests("너무 많은 요청입니다. 잠시 후 다시 시도해주세요.")

        response = self.get_response(request)
        return response

    def is_rate_limited(self, request):
        ip = self.get_client_ip(request)
        cache_key = f"rate_limit_{ip}"
        
        current_requests = cache.get(cache_key, 0)
        if current_requests >= 100:  # 1분에 100회 제한
            return True
        
        cache.set(cache_key, current_requests + 1, 60)  # 1분간 카운트
        return False
```

## ? 보안 취약점 대응

### 3.1 OWASP Top 10 대응

#### A01: Broken Access Control
```python
# 수직적 권한 상승 방지
@login_required
def admin_dashboard(request):
    if not request.user.is_staff:
        raise PermissionDenied("관리자 권한이 필요합니다.")
    return render(request, 'admin/dashboard.html')

# 수평적 권한 상승 방지
@login_required
def user_profile(request, user_id):
    if request.user.id != user_id and not request.user.is_staff:
        raise PermissionDenied("다른 사용자의 프로필에 접근할 수 없습니다.")
    user = get_object_or_404(CustomUser, id=user_id)
    return render(request, 'profile.html', {'user': user})
```

#### A02: Cryptographic Failures
```python
# 강력한 암호화 사용
ENCRYPTION_KEY = config('ENCRYPTION_KEY')  # 환경변수에서 로드
SECRET_KEY = config('SECRET_KEY')  # 랜덤하고 충분히 긴 키 사용

# HTTPS 강제 적용
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
```

#### A03: Injection
```python
# 원시 쿼리 사용 시 매개변수 바인딩
def search_courses(query):
    # 안전하지 않은 방법
    # sql = f"SELECT * FROM courses WHERE title LIKE '%{query}%'"
    
    # 안전한 방법
    return Course.objects.filter(title__icontains=query)
```

### 3.2 보안 헤더 설정
```python
# 보안 헤더 설정
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_HSTS_SECONDS = 31536000  # 1년
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

X_FRAME_OPTIONS = 'DENY'  # 클릭재킹 방지
SECURE_REFERRER_POLICY = 'strict-origin-when-cross-origin'

# CSP (Content Security Policy) 설정
CSP_DEFAULT_SRC = ("'self'",)
CSP_SCRIPT_SRC = ("'self'", "'unsafe-inline'")
CSP_STYLE_SRC = ("'self'", "'unsafe-inline'")
CSP_IMG_SRC = ("'self'", "data:", "https:")
```

## ? 보안 점검 체크리스트

### 4.1 일일 보안 점검
- [ ] 로그인 실패 로그 검토
- [ ] 비정상적인 트래픽 패턴 확인
- [ ] 시스템 리소스 사용량 모니터링
- [ ] 백업 상태 확인

### 4.2 주간 보안 점검
- [ ] 보안 패치 업데이트 확인
- [ ] 사용자 계정 활동 검토
- [ ] 로그 파일 분석
- [ ] 인증서 만료일 확인

### 4.3 월간 보안 점검
- [ ] 침투 테스트 수행
- [ ] 보안 정책 검토
- [ ] 직원 보안 교육
- [ ] 백업 복구 테스트

## ? 보안 인시던트 대응

### 5.1 인시던트 분류
- **Level 1**: 정보 유출 가능성
- **Level 2**: 시스템 침해 시도
- **Level 3**: 서비스 중단 위험
- **Level 4**: 중요 데이터 손실

### 5.2 대응 절차
```python
class SecurityIncidentHandler:
    def handle_incident(self, incident_type, severity, details):
        # 1. 즉시 대응
        self.immediate_response(incident_type)
        
        # 2. 로그 수집
        self.collect_logs(details)
        
        # 3. 관련자 통지
        self.notify_stakeholders(severity)
        
        # 4. 복구 작업
        self.initiate_recovery()
        
        # 5. 사후 분석
        self.post_incident_analysis()
```

## ?? 보안 도구 및 라이브러리

### 6.1 사용 중인 보안 라이브러리
```python
# requirements-security.txt
django-security==0.16.0          # Django 보안 강화
django-csp==3.7                  # Content Security Policy
django-ratelimit==3.0.1          # Rate limiting
cryptography==41.0.7             # 암호화
python-decouple==3.8             # 환경변수 관리
sentry-sdk==1.38.0               # 오류 모니터링
```

### 6.2 보안 스캐닝 도구
```bash
# 의존성 취약점 검사
pip install safety
safety check

# 코드 보안 검사
pip install bandit
bandit -r mnd_lms_simple/

# Django 보안 검사
python manage.py check --deploy
```

---

**문서 정보**
- 작성일: 2025년 11월 12일
- 작성자: MND LMS 보안팀
- 검토자: 정보보호담당관
- 승인자: CISO (Chief Information Security Officer)
- 분류: 대외비
- 버전: 1.0

**보안 등급**: 대외비
**보안 검토**: 2025년 11월 12일 완료
**다음 검토일**: 2026년 11월 12일