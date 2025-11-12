# Initial data for MND LMS
from mnd_lms_simple.models import *
from datetime import date, timedelta

print("Loading initial data...")

# Create site settings
settings, created = SiteSettings.objects.get_or_create()
if created:
    settings.site_name = 'MND Learning Management System'
    settings.hero_title = 'Ministry of National Defense LMS'
    settings.hero_subtitle = 'Professional Military Education and Training System'
    settings.contact_email = 'admin@mnd.go.kr'
    settings.contact_phone = '02-1234-5678'
    settings.save()
    print('Site settings created!')

# Create boards
boards_data = [
    {'name': 'Notice Board', 'board_type': 'notice', 'description': 'Official announcements and notices', 'order': 1},
    {'name': 'Free Discussion', 'board_type': 'free', 'description': 'General discussion board', 'order': 2},
    {'name': 'Q&A', 'board_type': 'qna', 'description': 'Questions and answers', 'order': 3},
    {'name': 'Events', 'board_type': 'event', 'description': 'Special events and activities', 'order': 4},
]

for board_data in boards_data:
    board, created = Board.objects.get_or_create(
        name=board_data['name'],
        defaults=board_data
    )
    if created:
        print(f'Board created: {board.name}')

# Create course categories
categories_data = [
    {'name': 'Strategic Planning', 'description': 'Strategic and tactical planning courses', 'order': 1},
    {'name': 'Cybersecurity', 'description': 'Information security and cyber defense', 'order': 2},
    {'name': 'Leadership', 'description': 'Leadership and management training', 'order': 3},
    {'name': 'Technology', 'description': 'Military technology and systems', 'order': 4},
]

for cat_data in categories_data:
    category, created = CourseCategory.objects.get_or_create(
        name=cat_data['name'],
        defaults=cat_data
    )
    if created:
        print(f'Category created: {category.name}')

# Create sample courses
try:
    cat1 = CourseCategory.objects.get(name='Strategic Planning')
    cat2 = CourseCategory.objects.get(name='Cybersecurity')
    cat3 = CourseCategory.objects.get(name='Leadership')

    courses_data = [
        {
            'title': 'Advanced Strategic Planning',
            'category': cat1,
            'description': 'Comprehensive strategic planning for military operations',
            'instructor': 'Colonel Kim',
            'duration_weeks': 8,
            'level': 'advanced',
            'status': 'published',
            'max_students': 50,
            'current_students': 0,
            'price': 0,
            'start_date': date.today(),
            'end_date': date.today() + timedelta(weeks=8),
            'is_featured': True
        },
        {
            'title': 'Cybersecurity Fundamentals',
            'category': cat2,
            'description': 'Basic cybersecurity principles and practices',
            'instructor': 'Major Lee',
            'duration_weeks': 6,
            'level': 'intermediate',
            'status': 'published',
            'max_students': 40,
            'current_students': 0,
            'price': 0,
            'start_date': date.today(),
            'end_date': date.today() + timedelta(weeks=6)
        },
        {
            'title': 'Leadership Excellence',
            'category': cat3,
            'description': 'Developing leadership skills for modern military',
            'instructor': 'Captain Park',
            'duration_weeks': 4,
            'level': 'intermediate',
            'status': 'published',
            'max_students': 30,
            'current_students': 0,
            'price': 0,
            'start_date': date.today(),
            'end_date': date.today() + timedelta(weeks=4),
            'is_featured': True
        }
    ]

    for course_data in courses_data:
        course, created = Course.objects.get_or_create(
            title=course_data['title'],
            defaults=course_data
        )
        if created:
            print(f'Course created: {course.title}')

except Exception as e:
    print(f'Error creating courses: {e}')

print('Initial data loading completed!')