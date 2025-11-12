# React Frontend Server 시작 스크립트
Write-Host "React Frontend Server를 시작합니다..." -ForegroundColor Green

# 현재 디렉토리를 스크립트 위치로 설정
Set-Location $PSScriptRoot

# Node.js 설치 확인
try {
    $nodeVersion = node --version
    Write-Host "Node.js 버전: $nodeVersion" -ForegroundColor Yellow
} catch {
    Write-Host "Node.js가 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host "Node.js를 https://nodejs.org 에서 다운로드하여 설치해주세요." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# 의존성 설치
Write-Host "의존성을 설치합니다..." -ForegroundColor Yellow
try {
    npm install
    if ($LASTEXITCODE -ne 0) {
        throw "npm install failed"
    }
} catch {
    Write-Host "의존성 설치에 실패했습니다." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# React 개발 서버 시작
Write-Host "React 개발 서버를 시작합니다..." -ForegroundColor Green
Write-Host "브라우저에서 http://localhost:3000 으로 접속하세요" -ForegroundColor Cyan

try {
    npm start
} catch {
    Write-Host "React 서버 시작에 실패했습니다." -ForegroundColor Red
    Read-Host "Press Enter to exit"
}