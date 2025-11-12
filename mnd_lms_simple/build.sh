#!/usr/bin/env bash
# Render build script

set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Collect static files
python manage.py collectstatic --no-input

# Run database migrations
python manage.py migrate

# Create superuser if it doesn't exist
echo "from mnd_lms_simple.models import CustomUser; CustomUser.objects.filter(username='admin').exists() or CustomUser.objects.create_superuser('admin', 'admin@mnd.go.kr', 'yang1123!', first_name='Admin', last_name='User', grade='A')" | python manage.py shell

# Load initial data
python manage.py shell < initial_data.py || echo "Initial data loading skipped"