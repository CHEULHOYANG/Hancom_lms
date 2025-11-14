# 한컴 국방부 학습관리시스템 (Hancom MND LMS)

## 개요 (Overview)

한컴 국방부 학습관리시스템(Hancom Ministry of National Defense Learning Management System)은 대한민국 국방부의 교육 및 훈련 관리를 위한 웹 기반 플랫폼입니다.

This is a web-based Learning Management System designed for the Ministry of National Defense (MND) education and training management.

## 주요 기능 (Key Features)

### 1. 사용자 인증 시스템 (Authentication System)
- 학생(병사), 교관, 관리자 구분 로그인
- 세션 관리 및 보안
- 프로필 관리

### 2. 대시보드 (Dashboard)
- 실시간 통계 현황
- 진행 중인 교육 과정 표시
- 최근 활동 내역
- 수강생 및 교관 현황

### 3. 교육과정 관리 (Course Management)
- 군사훈련 기본과정 (Basic Military Training)
- 통신보안 교육 (Communication Security)
- 전술훈련 교육 (Tactical Training)
- 응급처치 및 구급 (Emergency Medical Training)
- 사이버전 대응 (Cyber Warfare Response)

### 4. 학생 관리 (Student Management)
- 학생 등록 및 관리
- 군번 기반 식별
- 수강 과정 추적
- 진도율 모니터링
- 검색 기능

### 5. 교관 관리 (Instructor Management)
- 교관 프로필 관리
- 담당 과정 배정
- 전문 분야 관리
- 교육 현황 추적

## 기술 스택 (Technology Stack)

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Storage**: LocalStorage (for demo purposes)
- **Design**: Responsive Web Design
- **Security**: Client-side validation

## 파일 구조 (File Structure)

```
Hancom_lms/
├── index.html              # 메인 HTML 파일
├── css/
│   └── style.css          # 스타일시트
├── js/
│   └── main.js            # JavaScript 기능
├── modules/               # 교육 모듈 (확장 가능)
├── data/                  # 데이터 파일 (확장 가능)
├── docs/                  # 문서
│   ├── README.md         # 시스템 문서
│   ├── USER_GUIDE.md     # 사용자 가이드
│   └── API.md            # API 문서
└── README.md             # 프로젝트 README
```

## 설치 및 실행 (Installation & Running)

### 방법 1: 직접 실행
1. 저장소 클론:
   ```bash
   git clone https://github.com/CHEULHOYANG/Hancom_lms.git
   cd Hancom_lms
   ```

2. 웹 브라우저로 `index.html` 파일 열기

### 방법 2: 로컬 서버 실행
```bash
# Python 3.x
python -m http.server 8000

# Node.js
npx http-server

# 브라우저에서 http://localhost:8000 접속
```

## 사용 방법 (How to Use)

### 1. 로그인
- 사용자 ID 입력 (군번 또는 교관ID)
- 비밀번호 입력
- 사용자 구분 선택 (학생/교관/관리자)
- 로그인 버튼 클릭

**데모 계정**: 모든 ID/비밀번호 조합이 작동합니다 (데모 모드)

### 2. 대시보드 탐색
- 상단 네비게이션 바를 통해 각 섹션 이동
- 통계 확인 및 최근 활동 모니터링

### 3. 교육과정 관리
- "교육과정" 섹션에서 가용 과정 확인
- 각 과정의 상세 정보 조회
- 신규 과정 추가 (관리자/교관)

### 4. 학생 관리
- 학생 목록 조회 및 검색
- 진도율 확인
- 학생 추가/수정

### 5. 교관 관리
- 교관 프로필 확인
- 담당 과정 관리
- 교관 배정 및 조정

## 보안 고려사항 (Security Considerations)

현재 시스템은 데모 버전으로, 실제 운영 환경에서는 다음 사항이 필수적으로 구현되어야 합니다:

1. **서버 사이드 인증**: 백엔드 인증 시스템 구축
2. **데이터베이스**: 실제 데이터 저장소 연결
3. **암호화**: 비밀번호 및 민감 정보 암호화
4. **HTTPS**: 보안 통신 프로토콜 사용
5. **접근 제어**: 역할 기반 접근 제어 (RBAC)
6. **감사 로그**: 모든 활동 기록 및 추적

## 확장 계획 (Future Enhancements)

- [ ] 백엔드 API 개발 (Node.js/Express 또는 Python/Django)
- [ ] 데이터베이스 통합 (PostgreSQL/MySQL)
- [ ] 실시간 화상 교육 기능
- [ ] 시험 및 평가 시스템
- [ ] 성적 관리 시스템
- [ ] 모바일 앱 개발
- [ ] 파일 업로드/다운로드 기능
- [ ] 알림 시스템
- [ ] 보고서 생성 기능
- [ ] 다국어 지원 확대

## 시스템 요구사항 (System Requirements)

### 클라이언트
- 모던 웹 브라우저 (Chrome, Firefox, Safari, Edge)
- JavaScript 활성화
- 최소 해상도: 1024x768

### 서버 (향후 구현)
- Node.js 14+ 또는 Python 3.8+
- PostgreSQL 12+ 또는 MySQL 8+
- 최소 4GB RAM
- 10GB 저장 공간

## 라이센스 (License)

Copyright © 2025 한컴 (Hancom). All rights reserved.

본 시스템은 대한민국 국방부와 한컴의 협력 프로젝트입니다.

## 지원 및 문의 (Support & Contact)

기술 지원이 필요하시거나 문의사항이 있으시면 다음으로 연락주시기 바랍니다:
- 이메일: support@hancom.com
- 전화: 1588-XXXX
- GitHub Issues: https://github.com/CHEULHOYANG/Hancom_lms/issues

## 기여자 (Contributors)

- Development Team: Hancom Inc.
- Project Sponsor: Ministry of National Defense, ROK

## 버전 이력 (Version History)

### v1.0.0 (2025-11-12)
- 초기 시스템 구축
- 기본 인증 시스템
- 대시보드 구현
- 교육과정 관리 기능
- 학생 및 교관 관리 기능
- 반응형 웹 디자인

---

**Note**: 이 시스템은 현재 프로토타입/데모 버전입니다. 실제 운영 환경 배포 전 보안 강화 및 백엔드 시스템 구축이 필요합니다.
