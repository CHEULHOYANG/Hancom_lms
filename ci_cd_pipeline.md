# GitHub Actions CI/CD Workflow

## Main CI/CD Pipeline

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

env:
  PYTHON_VERSION: '3.11'
  NODE_VERSION: '18'

jobs:
  # Security and Code Quality Checks
  security-checks:
    name: Security & Code Quality
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Full history for better analysis

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Cache pip dependencies
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements*.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements/development.txt

    # Static Application Security Testing (SAST)
    - name: Run Bandit Security Scan
      run: |
        pip install bandit[toml]
        bandit -r . -f json -o bandit-report.json || true
        bandit -r . --severity-level medium --confidence-level medium

    - name: Run Safety Check (Dependency Vulnerabilities)
      run: |
        pip install safety
        safety check --json --output safety-report.json || true
        safety check --short-report

    - name: Code Quality with flake8
      run: |
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

    - name: Code Formatting with Black
      run: |
        black --check --diff .

    - name: Import Sorting with isort
      run: |
        isort . --check-only --diff

    # Upload security reports
    - name: Upload Bandit Report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: bandit-report
        path: bandit-report.json

    - name: Upload Safety Report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: safety-report
        path: safety-report.json

  # Backend Tests
  backend-tests:
    name: Backend Tests
    runs-on: ubuntu-latest
    needs: security-checks

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_lms
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Cache pip dependencies
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements*.txt') }}

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements/development.txt

    - name: Set up environment variables
      run: |
        echo "SECRET_KEY=test-secret-key-for-ci" >> $GITHUB_ENV
        echo "DEBUG=False" >> $GITHUB_ENV
        echo "DB_NAME=test_lms" >> $GITHUB_ENV
        echo "DB_USER=postgres" >> $GITHUB_ENV
        echo "DB_PASSWORD=postgres" >> $GITHUB_ENV
        echo "DB_HOST=localhost" >> $GITHUB_ENV
        echo "DB_PORT=5432" >> $GITHUB_ENV
        echo "REDIS_URL=redis://localhost:6379" >> $GITHUB_ENV

    - name: Run Django migrations
      run: |
        python manage.py migrate --settings=config.settings.testing

    - name: Run unit tests with coverage
      run: |
        pytest --cov=. --cov-report=xml --cov-report=html --cov-report=term-missing -v

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        files: ./coverage.xml
        fail_ci_if_error: true

    - name: Upload test coverage report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: coverage-report
        path: htmlcov/

  # Frontend Tests
  frontend-tests:
    name: Frontend Tests
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./frontend

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
        cache-dependency-path: frontend/package-lock.json

    - name: Install dependencies
      run: npm ci

    - name: Run ESLint
      run: npm run lint

    - name: Run unit tests
      run: npm run test:coverage

    - name: Upload frontend coverage
      uses: actions/upload-artifact@v3
      with:
        name: frontend-coverage
        path: frontend/coverage/

  # Integration Tests
  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    needs: [backend-tests, frontend-tests]

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_lms
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ env.NODE_VERSION }}

    - name: Install Python dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements/development.txt

    - name: Install Node.js dependencies
      run: |
        cd frontend
        npm ci

    - name: Build frontend
      run: |
        cd frontend
        npm run build

    - name: Set up environment
      run: |
        echo "SECRET_KEY=test-secret-key-for-ci" >> $GITHUB_ENV
        echo "DEBUG=False" >> $GITHUB_ENV
        echo "DB_NAME=test_lms" >> $GITHUB_ENV
        echo "DB_USER=postgres" >> $GITHUB_ENV
        echo "DB_PASSWORD=postgres" >> $GITHUB_ENV
        echo "DB_HOST=localhost" >> $GITHUB_ENV

    - name: Run migrations
      run: python manage.py migrate --settings=config.settings.testing

    - name: Start Django server
      run: |
        python manage.py runserver --settings=config.settings.testing &
        sleep 10

    - name: Run integration tests
      run: pytest tests/integration/ -v

  # Dynamic Application Security Testing (DAST)
  security-testing:
    name: DAST Security Testing
    runs-on: ubuntu-latest
    needs: integration-tests
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_lms
        ports:
          - 5432:5432

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements/development.txt

    - name: Start Django server
      run: |
        python manage.py migrate --settings=config.settings.testing
        python manage.py runserver --settings=config.settings.testing &
        sleep 10

    - name: OWASP ZAP Baseline Scan
      uses: zaproxy/action-baseline@v0.7.0
      with:
        target: 'http://localhost:8000'
        rules_file_name: '.zap/rules.tsv'
        cmd_options: '-a'

    - name: Upload ZAP Report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: zap-report
        path: report_html.html

  # Build and Push Docker Images
  build-and-push:
    name: Build & Push Docker Images
    runs-on: ubuntu-latest
    needs: [backend-tests, frontend-tests, security-checks]
    if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop')

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Log in to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: |
          your-org/lms-backend
          your-org/lms-frontend
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-

    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: .
        file: ./Dockerfile.backend
        push: true
        tags: your-org/lms-backend:${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

    - name: Build and push frontend image
      uses: docker/build-push-action@v5
      with:
        context: ./frontend
        file: ./frontend/Dockerfile
        push: true
        tags: your-org/lms-frontend:${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  # Deploy to Staging
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: build-and-push
    if: github.ref == 'refs/heads/develop'
    environment: staging

    steps:
    - name: Deploy to staging server
      uses: appleboy/ssh-action@v1.0.0
      with:
        host: ${{ secrets.STAGING_HOST }}
        username: ${{ secrets.STAGING_USER }}
        key: ${{ secrets.STAGING_SSH_KEY }}
        script: |
          cd /opt/lms-staging
          docker-compose pull
          docker-compose up -d
          docker system prune -f

  # Deploy to Production
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [build-and-push, security-testing]
    if: github.ref == 'refs/heads/main'
    environment: production

    steps:
    - name: Deploy to production server
      uses: appleboy/ssh-action@v1.0.0
      with:
        host: ${{ secrets.PRODUCTION_HOST }}
        username: ${{ secrets.PRODUCTION_USER }}
        key: ${{ secrets.PRODUCTION_SSH_KEY }}
        script: |
          cd /opt/lms-production
          docker-compose pull
          docker-compose up -d
          docker system prune -f

    - name: Run post-deployment health checks
      run: |
        sleep 30
        curl -f ${{ secrets.PRODUCTION_URL }}/health/ || exit 1

  # Notification
  notify:
    name: Notify Team
    runs-on: ubuntu-latest
    needs: [deploy-staging, deploy-production]
    if: always()

    steps:
    - name: Notify Slack
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        channel: '#lms-deployments'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
      if: always()
```

## Security Scanning Configuration

```yaml
# .github/workflows/security-scan.yml
name: Security Scan

on:
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM
  workflow_dispatch:

jobs:
  dependency-check:
    name: Dependency Security Check
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install safety pip-audit

    - name: Run Safety check
      run: safety check --json --output safety-report.json

    - name: Run pip-audit
      run: pip-audit --format=json --output=pip-audit-report.json

    - name: Upload reports
      uses: actions/upload-artifact@v3
      with:
        name: security-reports
        path: |
          safety-report.json
          pip-audit-report.json

  secret-scan:
    name: Secret Detection
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        fetch-depth: 0

    - name: Run TruffleHog
      uses: trufflesecurity/trufflehog@main
      with:
        path: ./
        base: main
        head: HEAD
```

## ZAP Security Testing Configuration

```
# .zap/rules.tsv
10011	IGNORE	(Cookie Without Secure Flag)
10015	IGNORE	(Incomplete or No Cache-control and Pragma HTTP Header Set)
10017	IGNORE	(Cross-Domain JavaScript Source File Inclusion)
10020	IGNORE	(X-Frame-Options Header Not Set)
10021	IGNORE	(X-Content-Type-Options Header Missing)
10023	IGNORE	(Information Disclosure - Debug Error Messages)
10025	IGNORE	(Information Disclosure - Sensitive Information in URL)
10026	IGNORE	(HTTP Parameter Override)
10027	IGNORE	(Information Disclosure - Suspicious Comments)
10028	IGNORE	(Open Redirect)
10032	IGNORE	(Viewstate Scanner)
10040	IGNORE	(Secure Pages Include Mixed Content)
10041	IGNORE	(HTTP to HTTPS Insecure Transition in Form Post)
10042	IGNORE	(HTTPS to HTTP Insecure Transition in Form Post)
10043	IGNORE	(User Controllable JavaScript Event)
10044	IGNORE	(Big Redirect Response)
10045	IGNORE	(Source Code Disclosure - /WEB-INF folder)
```

## Pre-commit Hooks Configuration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 23.11.0
    hooks:
      - id: black
        language_version: python3.11

  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort

  - repo: https://github.com/pycqa/flake8
    rev: 6.1.0
    hooks:
      - id: flake8
        additional_dependencies: [flake8-docstrings]

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: ['-c', 'pyproject.toml']

  - repo: https://github.com/pycqa/pylint
    rev: v3.0.3
    hooks:
      - id: pylint
        additional_dependencies: [django]
```

## Code Quality Configuration

```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
    # directories
    \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
  | migrations
)/
'''

[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
known_django = "django"
sections = ["FUTURE", "STDLIB", "DJANGO", "THIRDPARTY", "FIRSTPARTY", "LOCALFOLDER"]

[tool.bandit]
exclude_dirs = ["tests", "*/migrations/*"]
skips = ["B101", "B601"]

[tool.coverage.run]
source = "."
omit = [
    "*/migrations/*",
    "*/venv/*",
    "*/tests/*",
    "manage.py",
    "config/wsgi.py",
    "config/asgi.py",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
]
```

## Requirements Files

```txt
# requirements/base.txt
Django==4.2.7
djangorestframework==3.14.0
django-cors-headers==4.3.1
django-environ==0.11.2
psycopg2-binary==2.9.9
redis==5.0.1
celery==5.3.4
Pillow==10.1.0
argon2-cffi==23.1.0
PyJWT==2.8.0
python-magic==0.4.27
bleach==6.1.0
django-extensions==3.2.3
gunicorn==21.2.0
whitenoise==6.6.0
sentry-sdk==1.38.0

# requirements/development.txt
-r base.txt
django-debug-toolbar==4.2.0
pytest==7.4.3
pytest-django==4.7.0
pytest-cov==4.1.0
factory-boy==3.3.0
black==23.11.0
flake8==6.1.0
isort==5.12.0
bandit==1.7.5
safety==2.3.5
pip-audit==2.6.1
pre-commit==3.6.0

# requirements/production.txt
-r base.txt
```

This comprehensive CI/CD pipeline includes:

1. **Security Checks**: SAST with Bandit, dependency vulnerability scanning with Safety
2. **Code Quality**: Black formatting, flake8 linting, isort import sorting
3. **Testing**: Unit tests, integration tests, coverage reporting
4. **DAST**: OWASP ZAP dynamic security testing
5. **Build & Deploy**: Docker image building and deployment to staging/production
6. **Notifications**: Slack notifications for deployment status

The pipeline ensures code quality, security, and reliable deployments while following DevSecOps best practices.