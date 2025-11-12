# MND LMS (Ministry of National Defense Learning Management System)

## ?? 국방부 학습관리시스템

Django 기반의 국방부 전용 학습관리시스템으로, 체계적인 교육과정 관리와 사용자 맞춤형 학습 환경을 제공합니다.

## ? 주요 기능

### ? 사용자 관리
- **CustomUser 모델**: 계급, 등급, 전화번호 등 국방부 특화 필드
- **데이터 마스킹**: 개인정보 보호를 위한 자동 마스킹 기능
- **권한 관리**: 관리자/일반사용자 구분 및 접근 제어

### ? 강의 관리
- **강의 카테고리**: 전략기획, 사이버보안, 리더십, 기술 등
- **강의 상태 관리**: 게시됨/비공개/준비중 상태 관리
- **수강신청 시스템**: 정원 관리 및 대기열 시스템

### ? 커뮤니티
- **게시판 시스템**: 공지사항, 자유토론, Q&A, 이벤트
- **실시간 소통**: 질의응답 및 토론 기능

### ?? 보안 기능
- **SQL 인젝션 방지**: Django ORM 활용
- **CSRF 보호**: Django 내장 보안 기능
- **세션 관리**: 보안 세션 처리
- **데이터 암호화**: 민감정보 보호

## ?? 기술 스택

- **Backend**: Django 5.2.8, Python 3.13
- **Database**: SQLite (개발), PostgreSQL (운영)
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Authentication**: Django Auth + Custom User Model
- **Deployment**: Render, GitHub Actions

## ? 프로젝트 구조

```
mnd_lms_simple/
├── manage.py                 # Django 관리 스크립트
├── mnd_lms_simple/          # 메인 애플리케이션
│   ├── __init__.py
│   ├── settings.py          # 설정 파일
│   ├── urls.py              # URL 라우팅
│   ├── views.py             # 뷰 로직
│   ├── models.py            # 데이터 모델
│   ├── admin.py             # 관리자 페이지
│   └── wsgi.py              # WSGI 설정
├── templates/               # 템플릿 파일
│   ├── home.html            # 메인 페이지
│   ├── login.html           # 로그인 페이지
│   ├── register.html        # 회원가입 페이지
│   ├── my_courses.html      # 내 강의 페이지
│   └── admin/               # 관리자 템플릿
│       ├── base_admin.html
│       ├── custom_dashboard.html
│       ├── user_management.html
│       ├── course_management.html
│       ├── board_management.html
│       └── site_settings.html
└── db.sqlite3               # 데이터베이스 파일
```

## ? 설치 및 실행

### 1. 환경 설정
```bash
# 가상환경 생성 (선택사항)
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 패키지 설치
pip install -r requirements.txt
```

### 2. 데이터베이스 설정
```bash
python manage.py makemigrations
python manage.py migrate
```

### 3. 관리자 계정 생성
```bash
python manage.py createsuperuser
# 또는 기본 관리자 계정: admin / yang1123!
```

### 4. 서버 실행
```bash
python manage.py runserver
```

## ? 접속 정보

- **메인 페이지**: http://127.0.0.1:8000/
- **관리자 페이지**: http://127.0.0.1:8000/admin/
- **사용자 대시보드**: http://127.0.0.1:8000/admin-dashboard/

## ? 기본 계정

### 관리자 계정
- **사용자명**: admin
- **비밀번호**: yang1123!

## ? 주요 페이지

### 사용자 페이지
- `/` - 메인 홈페이지
- `/login/` - 로그인
- `/register/` - 회원가입
- `/my-courses/` - 내 강의

### 관리자 페이지
- `/admin-dashboard/` - 관리자 대시보드
- `/admin/users/` - 사용자 관리
- `/admin/courses/` - 강의 관리
- `/admin/boards/` - 게시판 관리
- `/admin/settings/` - 사이트 설정

## ? 보안 사항

### 적용된 보안 기능
1. **인증 시스템**: Django 내장 인증 + 커스텀 확장
2. **권한 관리**: 관리자/사용자 역할 기반 접근 제어
3. **데이터 보호**: 개인정보 마스킹 처리
4. **세션 보안**: 안전한 세션 관리
5. **입력 검증**: Form validation 및 데이터 검증

### 추가 권장 사항
1. HTTPS 적용 (운영 환경)
2. 정기적인 보안 업데이트
3. 백업 및 복구 계획
4. 로그 모니터링

## ? 데이터베이스 모델

### 주요 모델
- **CustomUser**: 사용자 정보 및 국방부 특화 필드
- **Course**: 강의 정보
- **CourseCategory**: 강의 카테고리
- **Enrollment**: 수강신청 관리
- **Board**: 게시판 정보
- **Post**: 게시글 관리
- **SiteSettings**: 사이트 설정

## ? 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ? 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## ? 연락처

- **프로젝트 관리자**: MND LMS Team
- **이메일**: admin@mnd-lms.go.kr
- **GitHub**: https://github.com/mnd-lms/mnd-lms-system

## ? 향후 계획

### Phase 2 (예정)
- [ ] 실시간 화상강의 시스템
- [ ] 모바일 앱 개발
- [ ] AI 기반 학습 추천
- [ ] 고급 분석 대시보드

### Phase 3 (예정)
- [ ] 다중 언어 지원
- [ ] 클라우드 확장
- [ ] API 고도화
- [ ] 외부 시스템 연동

---

**Made with ?? for Ministry of National Defense**