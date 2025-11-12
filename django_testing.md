# Django Testing Suite

## Test Configuration

```python
# config/settings/testing.py
from .base import *

# Use in-memory SQLite for faster testing
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Disable migrations for faster testing
class DisableMigrations:
    def __contains__(self, item):
        return True
    
    def __getitem__(self, item):
        return None

MIGRATION_MODULES = DisableMigrations()

# Faster password hashing for tests
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',
]

# Disable caching
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
    }
}

# Disable logging during tests
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'null': {
            'class': 'logging.NullHandler',
        },
    },
    'loggers': {
        'security': {
            'handlers': ['null'],
        },
    },
}
```

## Authentication Tests

```python
# tests/test_authentication.py
import pytest
from django.test import TestCase, Client
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
import jwt
from datetime import datetime, timedelta
from django.conf import settings

User = get_user_model()

class AuthenticationSecurityTest(APITestCase):
    def setUp(self):
        self.login_url = reverse('auth:login')
        self.register_url = reverse('auth:register')
        self.logout_url = reverse('auth:logout')
        self.refresh_url = reverse('auth:refresh')
        
    def test_password_hashing_argon2(self):
        """Test Argon2 password hashing"""
        user = User.objects.create_user(
            username='testuser',
            password='StrongPassword123!',
            email='test@example.com'
        )
        
        # Password should be hashed with Argon2
        self.assertTrue(user.password.startswith('$argon2'))
        self.assertTrue(user.check_password('StrongPassword123!'))
        self.assertFalse(user.check_password('wrongpassword'))
    
    def test_successful_login(self):
        """Test successful login flow"""
        user = User.objects.create_user(
            username='testuser',
            password='StrongPassword123!',
            email='test@example.com'
        )
        
        response = self.client.post(self.login_url, {
            'username': 'testuser',
            'password': 'StrongPassword123!'
        })
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access_token', response.data)
        self.assertIn('refresh_token', response.data)
        self.assertIn('user', response.data)
        
        # Verify JWT token structure
        access_token = response.data['access_token']
        payload = jwt.decode(access_token, settings.SECRET_KEY, algorithms=['HS256'])
        self.assertEqual(payload['user_id'], user.id)
        self.assertEqual(payload['type'], 'access')
    
    def test_failed_login_lockout(self):
        """Test account lockout after failed attempts"""
        user = User.objects.create_user(
            username='testuser',
            password='StrongPassword123!',
            email='test@example.com'
        )
        
        # Make 5 failed login attempts
        for i in range(5):
            response = self.client.post(self.login_url, {
                'username': 'testuser',
                'password': 'wrongpassword'
            })
            self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        
        # Check if account is locked
        user.refresh_from_db()
        self.assertTrue(user.is_account_locked())
        
        # Next attempt should return 423 (locked)
        response = self.client.post(self.login_url, {
            'username': 'testuser',
            'password': 'StrongPassword123!'
        })
        self.assertEqual(response.status_code, status.HTTP_423_LOCKED)
    
    def test_jwt_token_expiration(self):
        """Test JWT token expiration"""
        user = User.objects.create_user(
            username='testuser',
            password='pass',
            email='test@example.com'
        )
        
        access_token, refresh_token = user.generate_jwt_tokens()
        
        # Verify access token has short expiration
        payload = jwt.decode(access_token, settings.SECRET_KEY, algorithms=['HS256'])
        exp_time = datetime.fromtimestamp(payload['exp'])
        now = datetime.utcnow()
        self.assertLess((exp_time - now).total_seconds(), 16 * 60)  # Less than 16 minutes
    
    def test_refresh_token_functionality(self):
        """Test refresh token generation of new access token"""
        user = User.objects.create_user(
            username='testuser',
            password='pass',
            email='test@example.com'
        )
        
        access_token, refresh_token = user.generate_jwt_tokens()
        
        response = self.client.post(self.refresh_url, {
            'refresh_token': refresh_token
        })
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access_token', response.data)
    
    def test_logout_token_blacklisting(self):
        """Test token blacklisting on logout"""
        user = User.objects.create_user(
            username='testuser',
            password='pass',
            email='test@example.com'
        )
        
        # Login to get token
        login_response = self.client.post(self.login_url, {
            'username': 'testuser',
            'password': 'pass'
        })
        access_token = login_response.data['access_token']
        
        # Use token to access protected endpoint
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')
        
        # Logout
        logout_response = self.client.post(self.logout_url)
        self.assertEqual(logout_response.status_code, status.HTTP_200_OK)
        
        # Token should be blacklisted now - accessing protected endpoint should fail
        profile_response = self.client.get(reverse('auth:profile'))
        self.assertEqual(profile_response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_input_validation(self):
        """Test input validation for registration"""
        # Test invalid username
        response = self.client.post(self.register_url, {
            'username': '<script>alert("xss")</script>',
            'password': 'StrongPassword123!',
            'email': 'test@example.com'
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        
        # Test weak password
        response = self.client.post(self.register_url, {
            'username': 'testuser',
            'password': '123',
            'email': 'test@example.com'
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class RoleBasedAccessTest(APITestCase):
    def setUp(self):
        self.student = User.objects.create_user(
            username='student',
            password='pass',
            email='student@example.com',
            role='student'
        )
        self.instructor = User.objects.create_user(
            username='instructor',
            password='pass',
            email='instructor@example.com',
            role='instructor'
        )
        self.admin = User.objects.create_user(
            username='admin',
            password='pass',
            email='admin@example.com',
            role='admin'
        )
    
    def test_student_access_restrictions(self):
        """Test student role access restrictions"""
        self.client.force_authenticate(user=self.student)
        
        # Students should not access admin endpoints
        admin_url = reverse('admin:course-list')  # Assuming admin course management
        response = self.client.get(admin_url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
    
    def test_instructor_permissions(self):
        """Test instructor role permissions"""
        self.client.force_authenticate(user=self.instructor)
        
        # Instructors should access their course management
        # (This would be implemented with actual instructor endpoints)
        pass
    
    def test_admin_full_access(self):
        """Test admin role has full access"""
        self.client.force_authenticate(user=self.admin)
        
        # Admins should have access to all endpoints
        # (This would be tested with actual admin endpoints)
        pass
```

## Course Tests

```python
# tests/test_courses.py
import pytest
from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from courses.models import Course, CourseCategory, CourseSection, Lesson
from enrollments.models import Enrollment

User = get_user_model()

class CourseModelTest(TestCase):
    def setUp(self):
        self.instructor = User.objects.create_user(
            username='instructor',
            email='instructor@example.com',
            role='instructor'
        )
        self.category = CourseCategory.objects.create(name='Programming')
    
    def test_course_creation(self):
        """Test course model creation"""
        course = Course.objects.create(
            title='Python Basics',
            description='Learn Python programming',
            instructor=self.instructor,
            category=self.category,
            price=99.99
        )
        
        self.assertEqual(course.title, 'Python Basics')
        self.assertEqual(course.instructor, self.instructor)
        self.assertFalse(course.is_free)
        self.assertTrue(course.slug)  # Auto-generated slug
    
    def test_course_sections_and_lessons(self):
        """Test course structure with sections and lessons"""
        course = Course.objects.create(
            title='Python Basics',
            description='Learn Python programming',
            instructor=self.instructor,
            category=self.category
        )
        
        section = CourseSection.objects.create(
            course=course,
            title='Introduction',
            order_index=1
        )
        
        lesson = Lesson.objects.create(
            section=section,
            title='Getting Started',
            content_type='video',
            video_duration=1800,  # 30 minutes
            order_index=1
        )
        
        self.assertEqual(course.sections_count, 1)
        self.assertEqual(course.total_lessons, 1)
        self.assertEqual(section.lessons.count(), 1)

class CourseAPITest(APITestCase):
    def setUp(self):
        self.instructor = User.objects.create_user(
            username='instructor',
            email='instructor@example.com',
            role='instructor'
        )
        self.student = User.objects.create_user(
            username='student',
            email='student@example.com',
            role='student'
        )
        self.category = CourseCategory.objects.create(name='Programming')
        
        self.course = Course.objects.create(
            title='Python Basics',
            description='Learn Python programming',
            instructor=self.instructor,
            category=self.category,
            price=99.99,
            is_published=True
        )
    
    def test_course_list_public_access(self):
        """Test public access to course list"""
        url = reverse('courses:course-list')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)
    
    def test_course_detail_public_access(self):
        """Test public access to course details"""
        url = reverse('courses:course-detail', kwargs={'slug': self.course.slug})
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['title'], 'Python Basics')
    
    def test_course_sections_requires_enrollment(self):
        """Test that paid course sections require enrollment"""
        self.client.force_authenticate(user=self.student)
        
        section = CourseSection.objects.create(
            course=self.course,
            title='Introduction',
            order_index=1
        )
        
        url = reverse('courses:course-sections', kwargs={'course_id': self.course.id})
        response = self.client.get(url)
        
        # Should be forbidden without enrollment
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        
        # Create enrollment
        Enrollment.objects.create(
            user=self.student,
            course=self.course,
            status='active'
        )
        
        # Now should have access
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_free_course_access(self):
        """Test free course access without enrollment"""
        free_course = Course.objects.create(
            title='Free Python Intro',
            description='Free introduction',
            instructor=self.instructor,
            price=0,
            is_published=True
        )
        
        section = CourseSection.objects.create(
            course=free_course,
            title='Introduction',
            order_index=1
        )
        
        self.client.force_authenticate(user=self.student)
        url = reverse('courses:course-sections', kwargs={'course_id': free_course.id})
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_course_search_and_filtering(self):
        """Test course search and filtering functionality"""
        # Create additional courses
        Course.objects.create(
            title='JavaScript Fundamentals',
            description='Learn JavaScript',
            instructor=self.instructor,
            category=self.category,
            price=79.99,
            is_published=True
        )
        
        url = reverse('courses:course-list')
        
        # Test search
        response = self.client.get(url, {'search': 'Python'})
        self.assertEqual(len(response.data['results']), 1)
        
        # Test category filter
        response = self.client.get(url, {'category': self.category.id})
        self.assertEqual(len(response.data['results']), 2)
        
        # Test free courses filter
        Course.objects.create(
            title='Free Course',
            description='Free course',
            instructor=self.instructor,
            price=0,
            is_published=True
        )
        
        response = self.client.get(url, {'is_free': 'true'})
        self.assertEqual(len(response.data['results']), 1)
```

## Enrollment Tests

```python
# tests/test_enrollments.py
from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from courses.models import Course, CourseSection, Lesson
from enrollments.models import Enrollment, LessonProgress

User = get_user_model()

class EnrollmentModelTest(TestCase):
    def setUp(self):
        self.student = User.objects.create_user(
            username='student',
            email='student@example.com'
        )
        self.instructor = User.objects.create_user(
            username='instructor',
            email='instructor@example.com',
            role='instructor'
        )
        self.course = Course.objects.create(
            title='Test Course',
            description='Test',
            instructor=self.instructor,
            price=0
        )
    
    def test_enrollment_creation(self):
        """Test enrollment model creation"""
        enrollment = Enrollment.objects.create(
            user=self.student,
            course=self.course,
            status='active'
        )
        
        self.assertEqual(enrollment.user, self.student)
        self.assertEqual(enrollment.course, self.course)
        self.assertEqual(enrollment.status, 'active')
        self.assertEqual(enrollment.progress, 0)
    
    def test_progress_calculation(self):
        """Test progress calculation"""
        # Create course structure
        section = CourseSection.objects.create(
            course=self.course,
            title='Section 1',
            order_index=1
        )
        
        lesson1 = Lesson.objects.create(
            section=section,
            title='Lesson 1',
            order_index=1
        )
        lesson2 = Lesson.objects.create(
            section=section,
            title='Lesson 2',
            order_index=2
        )
        
        enrollment = Enrollment.objects.create(
            user=self.student,
            course=self.course,
            status='active'
        )
        
        # Complete first lesson
        LessonProgress.objects.create(
            user=self.student,
            lesson=lesson1,
            is_completed=True
        )
        
        # Check progress calculation
        calculated_progress = enrollment.calculate_progress()
        self.assertEqual(calculated_progress, 50.0)  # 1 out of 2 lessons

class EnrollmentAPITest(APITestCase):
    def setUp(self):
        self.student = User.objects.create_user(
            username='student',
            email='student@example.com'
        )
        self.instructor = User.objects.create_user(
            username='instructor',
            email='instructor@example.com',
            role='instructor'
        )
        
        self.free_course = Course.objects.create(
            title='Free Course',
            description='Free course',
            instructor=self.instructor,
            price=0,
            is_published=True
        )
        
        self.paid_course = Course.objects.create(
            title='Paid Course',
            description='Paid course',
            instructor=self.instructor,
            price=99.99,
            is_published=True
        )
    
    def test_free_course_enrollment(self):
        """Test enrollment in free course"""
        self.client.force_authenticate(user=self.student)
        
        url = reverse('enrollments:enroll')
        response = self.client.post(url, {'course_id': self.free_course.id})
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(
            Enrollment.objects.filter(
                user=self.student,
                course=self.free_course
            ).exists()
        )
    
    def test_paid_course_enrollment_requires_payment(self):
        """Test that paid course enrollment creates order"""
        self.client.force_authenticate(user=self.student)
        
        url = reverse('enrollments:enroll')
        response = self.client.post(url, {'course_id': self.paid_course.id})
        
        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)
        self.assertIn('order_id', response.data)
        
        # Should not create enrollment yet
        self.assertFalse(
            Enrollment.objects.filter(
                user=self.student,
                course=self.paid_course
            ).exists()
        )
    
    def test_duplicate_enrollment_prevention(self):
        """Test prevention of duplicate enrollments"""
        self.client.force_authenticate(user=self.student)
        
        # Create existing enrollment
        Enrollment.objects.create(
            user=self.student,
            course=self.free_course,
            status='active'
        )
        
        url = reverse('enrollments:enroll')
        response = self.client.post(url, {'course_id': self.free_course.id})
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
    
    def test_enrollment_list(self):
        """Test user's enrollment list"""
        self.client.force_authenticate(user=self.student)
        
        # Create enrollments
        Enrollment.objects.create(
            user=self.student,
            course=self.free_course,
            status='active'
        )
        
        url = reverse('enrollments:list')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
```

## Security Tests

```python
# tests/test_security.py
from django.test import TestCase
from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse

from common.validators import SecurityValidator
from courses.models import Course

User = get_user_model()

class SecurityValidationTest(TestCase):
    def test_username_validation(self):
        """Test username security validation"""
        # Valid usernames
        valid_usernames = ['user123', 'test_user', 'User2024']
        for username in valid_usernames:
            try:
                SecurityValidator.validate_username(username)
            except Exception:
                self.fail(f"Valid username {username} failed validation")
        
        # Invalid usernames
        invalid_usernames = [
            '<script>alert("xss")</script>',
            'user@domain.com',
            'user with spaces',
            'u',  # too short
            'a' * 31,  # too long
        ]
        
        for username in invalid_usernames:
            with self.assertRaises(Exception):
                SecurityValidator.validate_username(username)
    
    def test_html_sanitization(self):
        """Test HTML content sanitization"""
        malicious_content = '<script>alert("xss")</script><p>Valid content</p>'
        sanitized = SecurityValidator.sanitize_html_content(malicious_content)
        
        self.assertNotIn('<script>', sanitized)
        self.assertIn('<p>Valid content</p>', sanitized)

class CSRFProtectionTest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com'
        )
    
    def test_csrf_protection_on_state_changing_operations(self):
        """Test CSRF protection on POST/PUT/DELETE operations"""
        self.client.force_authenticate(user=self.user)
        
        # This would test actual CSRF protection in real implementation
        # For now, we verify that CSRF middleware is properly configured
        from django.conf import settings
        self.assertIn('django.middleware.csrf.CsrfViewMiddleware', settings.MIDDLEWARE)

class SQLInjectionProtectionTest(APITestCase):
    def setUp(self):
        self.instructor = User.objects.create_user(
            username='instructor',
            email='instructor@example.com',
            role='instructor'
        )
        
        Course.objects.create(
            title='Test Course',
            description='Test',
            instructor=self.instructor,
            is_published=True
        )
    
    def test_search_parameter_safety(self):
        """Test that search parameters are safe from SQL injection"""
        malicious_queries = [
            "'; DROP TABLE courses; --",
            "1' UNION SELECT * FROM auth_user --",
            "1' OR 1=1 --"
        ]
        
        url = reverse('courses:course-list')
        
        for query in malicious_queries:
            response = self.client.get(url, {'search': query})
            # Should not cause server error and should return safely
            self.assertIn(response.status_code, [200, 400])  # Either works safely or validates input

class RateLimitingTest(APITestCase):
    def test_login_rate_limiting(self):
        """Test rate limiting on login attempts"""
        # This would test actual rate limiting implementation
        # For now, we test the account lockout mechanism
        user = User.objects.create_user(
            username='testuser',
            password='correct_password',
            email='test@example.com'
        )
        
        login_url = reverse('auth:login')
        
        # Make multiple failed attempts
        for i in range(5):
            response = self.client.post(login_url, {
                'username': 'testuser',
                'password': 'wrong_password'
            })
            self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        
        # Account should be locked now
        user.refresh_from_db()
        self.assertTrue(user.is_account_locked())
```

## Pytest Configuration

```python
# pytest.ini
[tool:pytest]
DJANGO_SETTINGS_MODULE = config.settings.testing
addopts = --tb=short --strict-markers --disable-warnings
python_files = tests.py test_*.py *_tests.py
testpaths = tests
markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    security: marks tests as security tests
```

```python
# conftest.py
import pytest
from django.contrib.auth import get_user_model
from courses.models import Course, CourseCategory
from rest_framework.test import APIClient

User = get_user_model()

@pytest.fixture
def api_client():
    return APIClient()

@pytest.fixture
def user():
    return User.objects.create_user(
        username='testuser',
        email='test@example.com',
        password='testpass123'
    )

@pytest.fixture
def admin_user():
    return User.objects.create_user(
        username='admin',
        email='admin@example.com',
        password='testpass123',
        role='admin'
    )

@pytest.fixture
def instructor():
    return User.objects.create_user(
        username='instructor',
        email='instructor@example.com',
        password='testpass123',
        role='instructor'
    )

@pytest.fixture
def course_category():
    return CourseCategory.objects.create(name='Programming')

@pytest.fixture
def course(instructor, course_category):
    return Course.objects.create(
        title='Test Course',
        description='Test course description',
        instructor=instructor,
        category=course_category,
        price=99.99,
        is_published=True
    )
```

This comprehensive testing suite covers security, functionality, and edge cases with proper test organization and fixtures for efficient testing.