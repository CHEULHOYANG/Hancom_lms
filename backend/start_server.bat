@echo off
echo ========================================
echo  Hancom Campus LMS - Django Backend
echo ========================================
echo.

cd /d "E:\202511_11_LMS\backend"

echo [1/3] 가상환경 활성화 중...
call venv\Scripts\activate

echo [2/3] Django 서버 시작 중...
echo.
echo 서버가 실행되면 다음 URL에서 접속 가능합니다:
echo ┌─────────────────────────────────────────┐
echo │ 메인 사이트: http://localhost:8000      │
echo │ API 문서:    http://localhost:8001/api/docs/ │
echo │ 관리자:      http://localhost:8000/admin   │
echo └─────────────────────────────────────────┘
echo.
echo 서버를 중지하려면 Ctrl+C를 누르세요.
echo.

python manage.py runserver

pause