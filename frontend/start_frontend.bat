@echo off
echo React Frontend Server를 시작합니다...
cd /d "%~dp0"

:: Node.js 설치 확인
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js가 설치되어 있지 않습니다.
    echo Node.js를 https://nodejs.org 에서 다운로드하여 설치해주세요.
    pause
    exit /b 1
)

:: 의존성 설치
echo 의존성을 설치합니다...
npm install

if %errorlevel% neq 0 (
    echo 의존성 설치에 실패했습니다.
    pause
    exit /b 1
)

:: React 개발 서버 시작
echo React 개발 서버를 시작합니다...
echo 브라우저에서 http://localhost:3000 으로 접속하세요
npm start

pause