# LMS React Frontend

이 프로젝트는 Learning Management System의 React 기반 프론트엔드입니다.

## ? 시작하기

### 전제 조건

- Node.js (v16 이상)
- npm 또는 yarn

### 설치 및 실행

1. **의존성 설치**:
   ```bash
   npm install
   ```

2. **개발 서버 시작**:
   ```bash
   npm start
   ```
   
   또는 제공된 스크립트 사용:
   - Windows: `start_frontend.bat` 실행
   - PowerShell: `start_frontend.ps1` 실행

3. **브라우저에서 접속**:
   http://localhost:3000

## ? 프로젝트 구조

```
src/
├── components/          # 재사용 가능한 컴포넌트
│   ├── Layout.tsx      # 메인 레이아웃
│   └── PrivateRoute.tsx # 인증된 사용자만 접근 가능한 라우트
├── contexts/           # React 컨텍스트
│   └── AuthContext.tsx # 인증 관련 상태 관리
├── pages/              # 페이지 컴포넌트
│   ├── Login.tsx       # 로그인 페이지
│   ├── Register.tsx    # 회원가입 페이지
│   ├── Dashboard.tsx   # 대시보드
│   ├── Courses.tsx     # 전체 강의 목록
│   ├── MyCourses.tsx   # 내 강의
│   └── Profile.tsx     # 프로필 관리
├── App.tsx             # 메인 App 컴포넌트
└── index.tsx           # 진입점
```

## ? 주요 기능

### ? 인증 시스템
- JWT 기반 로그인/로그아웃
- 회원가입 (한글명, 영문명, 전화번호 포함)
- 자동 로그인 상태 유지
- 인증된 사용자만 접근 가능한 보호된 라우트

### ? 대시보드
- 학습 진행 상황 요약
- 완료된 강의 수
- 총 학습 시간
- 진행 중인 강의 표시

### ? 강의 관리
- 전체 강의 목록 조회
- 검색 및 필터링 (레벨별)
- 강의 상세 정보 (강사명, 시간, 가격, 평점)
- 강의 등록 기능

### ? 프로필 관리
- 개인정보 조회 및 수정
- 한글명/영문명 관리
- 연락처 정보 업데이트

## ? 기술 스택

- **React 18** with TypeScript
- **Material-UI (MUI)** for UI components
- **React Router** for navigation
- **Axios** for API calls
- **Context API** for state management

## ? 환경 설정

### 백엔드 API 연결

`package.json`의 `proxy` 설정으로 Django 백엔드와 연결:
```json
"proxy": "http://localhost:8000"
```

### Material-UI 테마

`src/index.tsx`에서 커스텀 테마 설정:
- Primary: #667eea (보라색 계열)
- Secondary: #764ba2 (진한 보라색)

## ? 반응형 디자인

- 모바일, 태블릿, 데스크톱 모든 디바이스 지원
- 모바일에서는 사이드바가 드로어로 변환
- Material-UI의 Grid 시스템 활용

## ? 보안 기능

- JWT 토큰 자동 헤더 설정
- 토큰 만료 시 자동 로그아웃
- HTTPS 대응 (프로덕션 환경)

## ? 빌드 및 배포

```bash
# 프로덕션 빌드
npm run build

# 빌드 파일은 build/ 폴더에 생성됩니다
```

## ? 문제 해결

### 의존성 오류
현재 의존성 패키지들이 설치되지 않은 상태입니다. Node.js 설치 후 `npm install`을 실행해주세요.

### 백엔드 연결 오류
Django 백엔드 서버가 http://localhost:8000에서 실행 중인지 확인해주세요.

## ? 지원 및 문의

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.