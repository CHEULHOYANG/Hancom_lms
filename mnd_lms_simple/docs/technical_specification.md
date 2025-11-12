# MND LMS 기술사항 명세서

## ?? 시스템 아키텍처

### 1.1 전체 아키텍처
```
[Client Browser] → [Load Balancer] → [Django Application] → [Database]
                                   ↓
                            [Static Files (CDN)]
```

### 1.2 기술 스택

#### Backend
- **Framework**: Django 5.2.8
- **Language**: Python 3.11+
- **Database**: PostgreSQL 15+ (운영), SQLite 3 (개발)
- **Web Server**: Gunicorn
- **Proxy Server**: Nginx (권장)

#### Frontend
- **HTML5**: 구조적 마크업
- **CSS3**: 반응형 디자인, Grid/Flexbox
- **JavaScript**: Vanilla JS (ES6+)
- **템플릿 엔진**: Django Templates

#### 인프라
- **클라우드**: Render Platform
- **정적 파일**: WhiteNoise + CDN
- **모니터링**: Django Admin + 외부 모니터링 도구
- **로그**: Python Logging + 파일 로그

## ?? 데이터베이스 설계

### 2.1 주요 테이블 구조

#### CustomUser (사용자)
```sql
CREATE TABLE mnd_lms_simple_customuser (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150) UNIQUE NOT NULL,
    email VARCHAR(254) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    real_name VARCHAR(50),
    phone VARCHAR(20),
    grade VARCHAR(1) CHECK (grade IN ('A', 'B', 'C', 'D')),
    login_count INTEGER DEFAULT 0,
    total_study_time INTEGER DEFAULT 0,
    last_login_ip INET,
    is_active BOOLEAN DEFAULT TRUE,
    is_staff BOOLEAN DEFAULT FALSE,
    is_superuser BOOLEAN DEFAULT FALSE,
    date_joined TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
```

#### Course (강의)
```sql
CREATE TABLE mnd_lms_simple_course (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    instructor VARCHAR(100),
    category_id INTEGER REFERENCES mnd_lms_simple_coursecategory(id),
    level VARCHAR(20) CHECK (level IN ('beginner', 'intermediate', 'advanced')),
    status VARCHAR(20) CHECK (status IN ('draft', 'published', 'archived')),
    duration_weeks INTEGER,
    max_students INTEGER DEFAULT 0,
    current_students INTEGER DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
```

#### Enrollment (수강신청)
```sql
CREATE TABLE mnd_lms_simple_enrollment (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES mnd_lms_simple_customuser(id),
    course_id INTEGER REFERENCES mnd_lms_simple_course(id),
    status VARCHAR(20) CHECK (status IN ('enrolled', 'completed', 'dropped')),
    progress DECIMAL(5,2) DEFAULT 0,
    enrolled_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(student_id, course_id)
);
```

### 2.2 인덱스 설계
```sql
-- 성능 최적화를 위한 인덱스
CREATE INDEX idx_course_category ON mnd_lms_simple_course(category_id);
CREATE INDEX idx_course_status ON mnd_lms_simple_course(status);
CREATE INDEX idx_enrollment_student ON mnd_lms_simple_enrollment(student_id);
CREATE INDEX idx_enrollment_course ON mnd_lms_simple_enrollment(course_id);
CREATE INDEX idx_user_email ON mnd_lms_simple_customuser(email);
CREATE INDEX idx_user_grade ON mnd_lms_simple_customuser(grade);
```

## ? 보안 설계

### 3.1 인증 및 권한
- **인증 방식**: Django Session Authentication
- **권한 모델**: Role-based Access Control (RBAC)
- **비밀번호**: Django PBKDF2 해싱
- **세션**: Secure Cookie + HTTPS Only

### 3.2 데이터 보호
```python
# 개인정보 마스킹 구현
def get_masked_email(self):
    if not self.email:
        return ''
    local, domain = self.email.split('@')
    if len(local) <= 2:
        return self.email
    return f"{local[:2]}{'*' * (len(local)-2)}@{domain}"

def get_masked_phone(self):
    if not self.phone:
        return ''
    if len(self.phone) <= 4:
        return self.phone
    return f"{self.phone[:3]}-{'*' * 4}-{self.phone[-4:]}"
```

### 3.3 입력 검증
```python
# Form Validation
class UserRegistrationForm(forms.Form):
    username = forms.CharField(
        validators=[RegexValidator(r'^[a-zA-Z][a-zA-Z0-9]{3,19}$')]
    )
    email = forms.EmailField()
    password = forms.CharField(
        validators=[MinLengthValidator(8)]
    )
```

## ? 성능 최적화

### 4.1 데이터베이스 최적화
- **Query Optimization**: select_related, prefetch_related 사용
- **Connection Pooling**: 연결 풀 관리
- **Caching**: Django Cache Framework
- **Pagination**: 대용량 데이터 페이징 처리

```python
# 최적화된 쿼리 예시
def get_courses_with_categories():
    return Course.objects.select_related('category').filter(
        status='published'
    ).order_by('-created_at')

def get_user_enrollments(user_id):
    return Enrollment.objects.select_related(
        'course', 'course__category'
    ).filter(student_id=user_id)
```

### 4.2 정적 파일 최적화
- **Static Files**: WhiteNoise를 통한 정적 파일 서빙
- **Compression**: Gzip 압축 적용
- **CDN**: Cloudflare 연동 권장
- **Caching**: Browser caching headers 설정

## ? 배포 및 운영

### 5.1 배포 파이프라인
```yaml
# GitHub Actions 배포 플로우
1. 코드 커밋 → GitHub
2. 자동 테스트 실행
3. 보안 검사 수행
4. Render 자동 배포
5. 헬스체크 확인
```

### 5.2 환경 설정
```python
# settings.py 환경별 설정
import os
from decouple import config

DEBUG = config('DEBUG', default=False, cast=bool)
SECRET_KEY = config('SECRET_KEY')
DATABASES = {
    'default': dj_database_url.config(
        default='sqlite:///db.sqlite3'
    )
}
```

### 5.3 로깅 설정
```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'django.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}
```

## ? 모니터링 및 유지보수

### 6.1 모니터링 항목
- **시스템 메트릭**: CPU, 메모리, 디스크 사용률
- **애플리케이션 메트릭**: 응답시간, 오류율, 처리량
- **비즈니스 메트릭**: 사용자 수, 강의 수강률, 페이지뷰

### 6.2 백업 전략
- **데이터베이스**: 일일 자동 백업
- **파일**: 정적 파일 및 미디어 파일 백업
- **코드**: Git 저장소 백업
- **설정**: 환경 설정 백업

### 6.3 장애 대응
```python
# 헬스체크 엔드포인트
def health_check(request):
    try:
        # DB 연결 확인
        CustomUser.objects.count()
        return JsonResponse({'status': 'healthy'})
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'error': str(e)
        }, status=500)
```

## ? 테스트 전략

### 7.1 테스트 레벨
- **Unit Tests**: 개별 함수 및 메서드 테스트
- **Integration Tests**: 컴포넌트 간 통합 테스트
- **System Tests**: 전체 시스템 기능 테스트
- **Security Tests**: 보안 취약점 테스트

### 7.2 테스트 도구
```python
# Django Test Framework
class UserModelTest(TestCase):
    def test_user_creation(self):
        user = CustomUser.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpass123'
        )
        self.assertEqual(user.username, 'testuser')
        self.assertTrue(user.check_password('testpass123'))
```

## ? 확장성 고려사항

### 8.1 수평 확장
- **로드 밸런서**: 트래픽 분산
- **데이터베이스**: 읽기 전용 복제본
- **캐시**: Redis 클러스터
- **파일 저장소**: 클라우드 스토리지

### 8.2 기능 확장
- **API**: Django REST Framework 추가
- **실시간**: WebSocket 지원
- **모바일**: React Native 앱
- **AI**: 머신러닝 기반 추천 시스템

---

**문서 정보**
- 작성일: 2025년 11월 12일
- 작성자: MND LMS 개발팀
- 검토자: 시스템 아키텍트
- 버전: 1.0