# 마이그레이션 실행 스크립트

## 1. 환경 설정 스크립트

```bash
#!/bin/bash
# setup_migration_env.sh

echo "=== LMS 마이그레이션 환경 설정 ==="

# Python 가상환경 생성
python -m venv migration_env
source migration_env/bin/activate  # Linux/Mac
# migration_env\Scripts\activate     # Windows

# 필요한 패키지 설치
pip install -r requirements.txt
pip install pyodbc  # SQL Server 연결용
pip install argon2-cffi  # 비밀번호 해싱용

# 마이그레이션 디렉토리 생성
mkdir -p migration_data
mkdir -p migration_logs
mkdir -p migration_backups

# 로그 파일 초기화
touch migration_logs/extract.log
touch migration_logs/migrate.log
touch migration_logs/validate.log

echo "환경 설정 완료!"
```

## 2. 배치 실행 스크립트 (Windows PowerShell)

```powershell
# run_migration.ps1
param(
    [string]$Stage = "all",
    [switch]$Force = $false,
    [switch]$Backup = $true
)

$ErrorActionPreference = "Stop"

# 로그 함수
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "migration_logs/migration.log" -Value $logMessage
}

# 백업 함수
function Backup-Database {
    if (-not $Backup) { return }
    
    Write-Log "데이터베이스 백업 시작..."
    
    try {
        # PostgreSQL 백업
        $backupFile = "migration_backups/django_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
        pg_dump -h localhost -U your_user -d lms_db > $backupFile
        Write-Log "백업 완료: $backupFile"
    }
    catch {
        Write-Log "백업 실패: $($_.Exception.Message)" "ERROR"
        if (-not $Force) { exit 1 }
    }
}

# 데이터 추출 함수
function Start-DataExtraction {
    Write-Log "데이터 추출 시작..."
    
    try {
        python scripts/extract_data.py 2>&1 | Tee-Object -FilePath "migration_logs/extract.log" -Append
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "데이터 추출 완료"
        } else {
            throw "데이터 추출 실패"
        }
    }
    catch {
        Write-Log "데이터 추출 오류: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

# 데이터 마이그레이션 함수
function Start-DataMigration {
    Write-Log "데이터 마이그레이션 시작..."
    
    try {
        python scripts/migrate_data.py 2>&1 | Tee-Object -FilePath "migration_logs/migrate.log" -Append
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "데이터 마이그레이션 완료"
        } else {
            throw "데이터 마이그레이션 실패"
        }
    }
    catch {
        Write-Log "데이터 마이그레이션 오류: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

# 데이터 검증 함수
function Start-DataValidation {
    Write-Log "데이터 검증 시작..."
    
    try {
        python scripts/validate_migration.py 2>&1 | Tee-Object -FilePath "migration_logs/validate.log" -Append
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "데이터 검증 완료"
        } else {
            throw "데이터 검증 실패"
        }
    }
    catch {
        Write-Log "데이터 검증 오류: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

# 메인 실행
Write-Log "=== LMS 마이그레이션 시작 ==="
Write-Log "실행 단계: $Stage"
Write-Log "강제 실행: $Force"
Write-Log "백업 수행: $Backup"

# 가상환경 활성화
Write-Log "가상환경 활성화..."
.\migration_env\Scripts\Activate.ps1

try {
    switch ($Stage) {
        "extract" {
            Start-DataExtraction
        }
        "migrate" {
            Backup-Database
            Start-DataMigration
        }
        "validate" {
            Start-DataValidation
        }
        "all" {
            Start-DataExtraction
            Backup-Database
            Start-DataMigration
            Start-DataValidation
        }
        default {
            Write-Log "알 수 없는 단계: $Stage" "ERROR"
            exit 1
        }
    }
    
    Write-Log "=== 마이그레이션 완료 ==="
}
catch {
    Write-Log "마이그레이션 실패: $($_.Exception.Message)" "ERROR"
    exit 1
}
```

## 3. Linux/Mac 배치 스크립트

```bash
#!/bin/bash
# run_migration.sh

set -e  # 오류 시 즉시 종료

# 기본 설정
STAGE=${1:-"all"}
FORCE=${2:-false}
BACKUP=${3:-true}

# 로그 함수
log() {
    local level=${2:-"INFO"}
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $1" | tee -a migration_logs/migration.log
}

# 백업 함수
backup_database() {
    if [ "$BACKUP" != "true" ]; then
        return 0
    fi
    
    log "데이터베이스 백업 시작..."
    
    local backup_file="migration_backups/django_backup_$(date '+%Y%m%d_%H%M%S').sql"
    
    if pg_dump -h localhost -U your_user -d lms_db > "$backup_file"; then
        log "백업 완료: $backup_file"
    else
        log "백업 실패" "ERROR"
        if [ "$FORCE" != "true" ]; then
            exit 1
        fi
    fi
}

# 데이터 추출 함수
extract_data() {
    log "데이터 추출 시작..."
    
    if python scripts/extract_data.py 2>&1 | tee -a migration_logs/extract.log; then
        log "데이터 추출 완료"
    else
        log "데이터 추출 실패" "ERROR"
        exit 1
    fi
}

# 데이터 마이그레이션 함수
migrate_data() {
    log "데이터 마이그레이션 시작..."
    
    if python scripts/migrate_data.py 2>&1 | tee -a migration_logs/migrate.log; then
        log "데이터 마이그레이션 완료"
    else
        log "데이터 마이그레이션 실패" "ERROR"
        exit 1
    fi
}

# 데이터 검증 함수
validate_data() {
    log "데이터 검증 시작..."
    
    if python scripts/validate_migration.py 2>&1 | tee -a migration_logs/validate.log; then
        log "데이터 검증 완료"
    else
        log "데이터 검증 실패" "ERROR"
        exit 1
    fi
}

# 메인 실행
log "=== LMS 마이그레이션 시작 ==="
log "실행 단계: $STAGE"
log "강제 실행: $FORCE"
log "백업 수행: $BACKUP"

# 가상환경 활성화
source migration_env/bin/activate

case $STAGE in
    "extract")
        extract_data
        ;;
    "migrate")
        backup_database
        migrate_data
        ;;
    "validate")
        validate_data
        ;;
    "all")
        extract_data
        backup_database
        migrate_data
        validate_data
        ;;
    *)
        log "알 수 없는 단계: $STAGE" "ERROR"
        exit 1
        ;;
esac

log "=== 마이그레이션 완료 ==="
```

## 4. 설정 파일

```python
# migration_config.py
import os
from datetime import datetime

# 데이터베이스 연결 설정
ASP_DATABASE_CONFIG = {
    'driver': 'ODBC Driver 17 for SQL Server',
    'server': 'HANCOMELEARNING\\HANCOM_DEFENSE',
    'database': 'hancom_defense',
    'username': 'hancomsqladmin',
    'password': 'zoavjtm!23',
    'charset': 'UTF8',
    'trusted_connection': 'no',
}

DJANGO_DATABASE_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'lms_db',
    'username': 'lms_user',
    'password': 'your_password',
}

# 마이그레이션 설정
MIGRATION_CONFIG = {
    'batch_size': 1000,  # 배치 크기
    'max_retry_count': 3,  # 재시도 횟수
    'timeout_seconds': 300,  # 타임아웃 (초)
    'backup_enabled': True,  # 백업 활성화
    'validation_enabled': True,  # 검증 활성화
    'temp_password': 'TempPassword123!',  # 임시 비밀번호
}

# 디렉토리 설정
DIRECTORIES = {
    'data': 'migration_data',
    'logs': 'migration_logs',
    'backups': 'migration_backups',
    'reports': 'migration_reports',
}

# 로그 설정
LOGGING_CONFIG = {
    'level': 'INFO',
    'format': '[%(asctime)s] [%(levelname)s] %(message)s',
    'date_format': '%Y-%m-%d %H:%M:%S',
    'files': {
        'extract': 'migration_logs/extract.log',
        'migrate': 'migration_logs/migrate.log',
        'validate': 'migration_logs/validate.log',
        'error': 'migration_logs/error.log',
    }
}

# 이메일 알림 설정 (선택사항)
EMAIL_CONFIG = {
    'enabled': False,
    'smtp_server': 'smtp.gmail.com',
    'smtp_port': 587,
    'username': 'your-email@gmail.com',
    'password': 'your-app-password',
    'recipients': ['admin@yourcompany.com'],
}

def get_connection_string():
    """ASP 데이터베이스 연결 문자열 생성"""
    config = ASP_DATABASE_CONFIG
    return (
        f"DRIVER={{{config['driver']}}};"
        f"SERVER={config['server']};"
        f"DATABASE={config['database']};"
        f"UID={config['username']};"
        f"PWD={config['password']};"
        f"CHARSET={config['charset']};"
    )

def get_django_db_url():
    """Django 데이터베이스 URL 생성"""
    config = DJANGO_DATABASE_CONFIG
    return (
        f"postgresql://{config['username']}:{config['password']}@"
        f"{config['host']}:{config['port']}/{config['database']}"
    )

def ensure_directories():
    """필요한 디렉토리 생성"""
    for directory in DIRECTORIES.values():
        os.makedirs(directory, exist_ok=True)

def get_timestamp():
    """현재 시간 문자열 반환"""
    return datetime.now().strftime('%Y%m%d_%H%M%S')
```

## 5. 모니터링 스크립트

```python
# scripts/monitor_migration.py
import json
import time
import os
import psutil
from datetime import datetime
import smtplib
from email.mime.text import MimeText
from email.mime.multipart import MimeMultipart

from migration_config import EMAIL_CONFIG, LOGGING_CONFIG

class MigrationMonitor:
    def __init__(self):
        self.start_time = datetime.now()
        self.status = {
            'stage': 'idle',
            'progress': 0,
            'current_task': '',
            'errors': [],
            'warnings': [],
            'system_info': {}
        }
    
    def update_status(self, stage, progress=0, task=''):
        """상태 업데이트"""
        self.status.update({
            'stage': stage,
            'progress': progress,
            'current_task': task,
            'last_update': datetime.now().isoformat()
        })
        self.save_status()
    
    def add_error(self, error_msg):
        """오류 추가"""
        error_entry = {
            'timestamp': datetime.now().isoformat(),
            'message': error_msg,
            'stage': self.status['stage']
        }
        self.status['errors'].append(error_entry)
        self.save_status()
        
        # 치명적 오류 시 이메일 알림
        if 'critical' in error_msg.lower() or 'fatal' in error_msg.lower():
            self.send_alert_email(f"Critical Error: {error_msg}")
    
    def add_warning(self, warning_msg):
        """경고 추가"""
        warning_entry = {
            'timestamp': datetime.now().isoformat(),
            'message': warning_msg,
            'stage': self.status['stage']
        }
        self.status['warnings'].append(warning_entry)
        self.save_status()
    
    def update_system_info(self):
        """시스템 정보 업데이트"""
        self.status['system_info'] = {
            'cpu_percent': psutil.cpu_percent(),
            'memory_percent': psutil.virtual_memory().percent,
            'disk_usage': psutil.disk_usage('/').percent,
            'elapsed_time': str(datetime.now() - self.start_time),
        }
    
    def save_status(self):
        """상태를 파일로 저장"""
        with open('migration_status.json', 'w', encoding='utf-8') as f:
            json.dump(self.status, f, ensure_ascii=False, indent=2, default=str)
    
    def load_status(self):
        """저장된 상태 로드"""
        try:
            with open('migration_status.json', 'r', encoding='utf-8') as f:
                self.status = json.load(f)
            return True
        except FileNotFoundError:
            return False
    
    def send_alert_email(self, subject, message=''):
        """알림 이메일 발송"""
        if not EMAIL_CONFIG['enabled']:
            return
        
        try:
            msg = MimeMultipart()
            msg['From'] = EMAIL_CONFIG['username']
            msg['To'] = ', '.join(EMAIL_CONFIG['recipients'])
            msg['Subject'] = f"LMS Migration Alert: {subject}"
            
            body = f"""
LMS 마이그레이션 알림

시간: {datetime.now().isoformat()}
단계: {self.status['stage']}
진행률: {self.status['progress']}%
현재 작업: {self.status['current_task']}

메시지: {message}

시스템 정보:
- CPU 사용률: {self.status['system_info'].get('cpu_percent', 'N/A')}%
- 메모리 사용률: {self.status['system_info'].get('memory_percent', 'N/A')}%
- 디스크 사용률: {self.status['system_info'].get('disk_usage', 'N/A')}%
- 경과 시간: {self.status['system_info'].get('elapsed_time', 'N/A')}

오류 개수: {len(self.status['errors'])}
경고 개수: {len(self.status['warnings'])}
            """
            
            msg.attach(MimeText(body, 'plain', 'utf-8'))
            
            server = smtplib.SMTP(EMAIL_CONFIG['smtp_server'], EMAIL_CONFIG['smtp_port'])
            server.starttls()
            server.login(EMAIL_CONFIG['username'], EMAIL_CONFIG['password'])
            
            text = msg.as_string()
            server.sendmail(EMAIL_CONFIG['username'], EMAIL_CONFIG['recipients'], text)
            server.quit()
            
            print(f"알림 이메일 발송 완료: {subject}")
            
        except Exception as e:
            print(f"이메일 발송 실패: {e}")
    
    def generate_report(self):
        """마이그레이션 완료 보고서 생성"""
        end_time = datetime.now()
        total_time = end_time - self.start_time
        
        report = {
            'migration_summary': {
                'start_time': self.start_time.isoformat(),
                'end_time': end_time.isoformat(),
                'total_duration': str(total_time),
                'final_stage': self.status['stage'],
                'final_progress': self.status['progress'],
            },
            'statistics': {
                'total_errors': len(self.status['errors']),
                'total_warnings': len(self.status['warnings']),
                'success_rate': max(0, 100 - len(self.status['errors']) * 10),
            },
            'errors': self.status['errors'],
            'warnings': self.status['warnings'],
            'system_performance': self.status['system_info']
        }
        
        # 보고서 저장
        report_file = f"migration_reports/migration_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        os.makedirs('migration_reports', exist_ok=True)
        
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, ensure_ascii=False, indent=2, default=str)
        
        print(f"마이그레이션 보고서 생성: {report_file}")
        
        # 완료 이메일 발송
        if report['statistics']['total_errors'] == 0:
            self.send_alert_email("Migration Completed Successfully", 
                                f"마이그레이션이 성공적으로 완료되었습니다. 소요 시간: {total_time}")
        else:
            self.send_alert_email("Migration Completed with Errors", 
                                f"마이그레이션이 완료되었지만 {report['statistics']['total_errors']}개의 오류가 발생했습니다.")
        
        return report

# 전역 모니터 인스턴스
migration_monitor = MigrationMonitor()
```

## 6. 사용법

```bash
# 전체 마이그레이션 실행
./run_migration.sh all

# 단계별 실행
./run_migration.sh extract  # 데이터 추출만
./run_migration.sh migrate  # 마이그레이션만
./run_migration.sh validate # 검증만

# 강제 실행 (오류 시에도 계속)
./run_migration.sh all true

# 백업 없이 실행
./run_migration.sh migrate false false

# Windows PowerShell에서 실행
.\run_migration.ps1 -Stage "all" -Force -Backup
```

이 실행 스크립트들은 마이그레이션 과정을 자동화하고 모니터링하여 안전하고 효율적인 데이터 이전을 보장합니다.