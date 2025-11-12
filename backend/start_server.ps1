# Hancom Campus LMS - Django Backend 실행 스크립트
# PowerShell용

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Hancom Campus LMS - Django Backend" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "E:\202511_11_LMS\backend"

Write-Host "[1/3] 가상환경 활성화 중..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

Write-Host "[2/3] Django 서버 시작 중..." -ForegroundColor Yellow
Write-Host ""
Write-Host "서버가 실행되면 다음 URL에서 접속 가능합니다:" -ForegroundColor Green
Write-Host "┌─────────────────────────────────────────┐" -ForegroundColor White
Write-Host "│ 메인 사이트: http://localhost:8000      │" -ForegroundColor White
Write-Host "│ API 문서:    http://localhost:8000/api/docs/ │" -ForegroundColor White  
Write-Host "│ 관리자:      http://localhost:8000/admin   │" -ForegroundColor White
Write-Host "└─────────────────────────────────────────┘" -ForegroundColor White
Write-Host ""
Write-Host "서버를 중지하려면 Ctrl+C를 누르세요." -ForegroundColor Red
Write-Host ""

python manage.py runserver

Read-Host "Press Enter to exit"