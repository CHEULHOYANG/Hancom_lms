# 한컴 국방부 학습관리시스템
# Hancom Ministry of National Defense Learning Management System

[![License](https://img.shields.io/badge/license-Proprietary-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/CHEULHOYANG/Hancom_lms)
[![Status](https://img.shields.io/badge/status-Active-success.svg)](https://github.com/CHEULHOYANG/Hancom_lms)

## 📋 개요 (Overview)

한컴 국방부 학습관리시스템(Hancom MND LMS)은 대한민국 국방부를 위한 웹 기반 교육 및 훈련 관리 플랫폼입니다. 이 시스템은 군사 교육과정 관리, 학생(병사) 및 교관 관리, 진도 추적 등의 기능을 제공합니다.

The Hancom Ministry of National Defense Learning Management System is a web-based education and training management platform designed for the Republic of Korea Ministry of National Defense. The system provides military course management, student (soldier) and instructor management, progress tracking, and more.

## ✨ 주요 기능 (Key Features)

- 🔐 **사용자 인증 시스템** - 학생, 교관, 관리자 구분 로그인
- 📊 **실시간 대시보드** - 교육 현황 및 통계 모니터링
- 📚 **교육과정 관리** - 군사 훈련 및 전문 교육 과정 관리
- 👥 **학생 관리** - 군번 기반 학생 등록 및 진도 추적
- 👨‍🏫 **교관 관리** - 교관 배정 및 담당 과정 관리
- 📈 **진도 추적** - 실시간 학습 진도율 모니터링
- 🔍 **검색 기능** - 학생 및 과정 빠른 검색
- 📱 **반응형 디자인** - 모바일 및 태블릿 지원

## 🎓 제공 교육과정 (Available Courses)

1. **군사훈련 기본과정** (MND-001) - 기본 군사훈련 및 체력단련
2. **통신보안 교육** (MND-002) - 군사통신 보안 및 암호화 기술
3. **전술훈련 교육** (MND-003) - 전술적 사고 및 작전 수행
4. **응급처치 및 구급** (MND-004) - 전장 응급처치 및 부상자 구급
5. **사이버전 대응** (MND-005) - 사이버 공격 및 방어 전략

## 🚀 빠른 시작 (Quick Start)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/CHEULHOYANG/Hancom_lms.git
   cd Hancom_lms
   ```

2. **웹 브라우저로 실행**
   - `index.html` 파일을 더블클릭하거나
   - 웹 브라우저에서 파일 열기

3. **로컬 서버 실행 (선택사항)**
   ```bash
   # Python 사용
   python -m http.server 8000
   
   # Node.js 사용
   npx http-server
   ```

4. **브라우저에서 접속**
   - http://localhost:8000

### 데모 로그인

현재 데모 버전에서는 모든 ID/비밀번호 조합이 작동합니다:
- **사용자 ID**: 임의의 텍스트 (예: admin, student01)
- **비밀번호**: 임의의 텍스트
- **사용자 구분**: 학생, 교관, 또는 관리자 선택

## 📁 프로젝트 구조 (Project Structure)

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
│   ├── README.md         # 상세 시스템 문서
│   ├── USER_GUIDE.md     # 사용자 가이드
│   └── API.md            # API 문서 (향후 구현)
└── README.md             # 프로젝트 README
```

## 🛠️ 기술 스택 (Technology Stack)

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Storage**: LocalStorage (데모용)
- **Design**: Responsive Web Design
- **Future Backend**: Node.js/Express 또는 Python/Django (계획 중)
- **Future Database**: PostgreSQL/MySQL (계획 중)

## 📖 문서 (Documentation)

- [시스템 상세 문서](docs/README.md) - 전체 시스템 개요 및 기능 설명
- [사용자 가이드](docs/USER_GUIDE.md) - 단계별 사용 방법
- [API 문서](docs/API.md) - API 명세 (향후 구현)

## 🔒 보안 (Security)

**중요**: 현재 버전은 데모/프로토타입입니다. 실제 운영 환경 배포 전 다음 사항이 필수적으로 구현되어야 합니다:

- ✅ 서버 사이드 인증 시스템
- ✅ 데이터베이스 통합
- ✅ 비밀번호 암호화
- ✅ HTTPS 보안 통신
- ✅ 역할 기반 접근 제어 (RBAC)
- ✅ 감사 로그 시스템

## 🔮 향후 개발 계획 (Future Enhancements)

- [ ] 백엔드 API 개발
- [ ] 데이터베이스 통합
- [ ] 실시간 화상 교육 기능
- [ ] 시험 및 평가 시스템
- [ ] 성적 관리 시스템
- [ ] 모바일 앱 개발
- [ ] 파일 업로드/다운로드
- [ ] 알림 시스템
- [ ] 보고서 생성 기능
- [ ] 다국어 지원 (영어, 한국어)

## 💻 시스템 요구사항 (System Requirements)

### 클라이언트
- 모던 웹 브라우저 (Chrome, Firefox, Safari, Edge)
- JavaScript 활성화 필수
- 권장 해상도: 1024x768 이상

### 서버 (향후 구현 시)
- Node.js 14+ 또는 Python 3.8+
- PostgreSQL 12+ 또는 MySQL 8+
- 최소 4GB RAM
- 10GB 저장 공간

## 🤝 기여 (Contributing)

이 프로젝트는 한컴과 대한민국 국방부의 협력 프로젝트입니다. 기여를 원하시면 다음 절차를 따라주세요:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 지원 및 문의 (Support & Contact)

- **이메일**: support@hancom.com
- **전화**: 1588-XXXX
- **GitHub Issues**: [Issues 페이지](https://github.com/CHEULHOYANG/Hancom_lms/issues)
- **문서**: [Wiki](https://github.com/CHEULHOYANG/Hancom_lms/wiki)

## 📄 라이센스 (License)

Copyright © 2025 한컴 (Hancom). All rights reserved.

본 시스템은 대한민국 국방부와 한컴의 협력으로 개발되었습니다.

## 🏆 제작진 (Credits)

- **개발**: Hancom Inc. Development Team
- **프로젝트 스폰서**: Ministry of National Defense, Republic of Korea
- **버전**: 1.0.0
- **최종 업데이트**: 2025-11-12

---

**⚠️ 주의사항**: 이 시스템은 현재 프로토타입/데모 버전입니다. 실제 운영 환경 배포 전 보안 강화 및 백엔드 시스템 구축이 필요합니다.

---

Made with ❤️ by Hancom for the Ministry of National Defense