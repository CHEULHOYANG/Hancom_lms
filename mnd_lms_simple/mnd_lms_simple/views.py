# -*- coding: utf-8 -*-
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q, Count
from django.utils import timezone
from django.contrib.auth import get_user_model
from .models import CustomUser, CourseCategory, Course, Enrollment, Board, Post, SiteSettings

User = get_user_model()

def home(request):
    context = {}
    if request.user.is_authenticated:
        context['user'] = request.user
        context['current_courses'] = [
            {'title': 'Office Course', 'progress': 75, 'instructor': 'Prof. Kim'},
            {'title': 'Excel Course', 'progress': 45, 'instructor': 'Prof. Lee'},
        ]
        context['completed_courses'] = [
            {'title': 'PowerPoint Course', 'completion_date': '2025-10-15', 'score': 95},
        ]
    else:
        context['recommended_courses'] = [
            {'title': 'Office Course', 'description': 'Basic office software skills'},
            {'title': 'Excel Course', 'description': 'Data analysis with Excel'},
            {'title': 'PowerPoint Course', 'description': 'Effective presentation skills'},
        ]
    
    return render(request, 'home.html', context)

def user_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if username == 'admin' and password == 'yang1123!':
            user = authenticate(request, username=username, password=password)
            if user:
                login(request, user)
                return redirect('/admin/')
        
        user = authenticate(request, username=username, password=password)
        if user and not user.is_superuser:
            login(request, user)
            messages.success(request, f'{user.get_full_name() or user.username} welcome!')
            return redirect('/')
        elif user and user.is_superuser:
            login(request, user)
            return redirect('/admin/')
        else:
            messages.error(request, 'Invalid username or password.')
    
    return render(request, 'login.html')

def register_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        grade = request.POST.get('grade')
        
        # Validate required fields
        if not all([username, password, name, email]):
            messages.error(request, 'Please fill in all required fields.')
            return render(request, 'register.html')
        
        # Check if username already exists
        if CustomUser.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists. Please choose another one.')
            return render(request, 'register.html')
        
        # Check if email already exists
        if CustomUser.objects.filter(email=email).exists():
            messages.error(request, 'Email already exists. Please use another email address.')
            return render(request, 'register.html')
        
        try:
            # Create new user using CustomUser model
            user = CustomUser.objects.create_user(
                username=username,
                password=password,
                email=email,
                first_name=name.split()[0] if name else '',
                last_name=' '.join(name.split()[1:]) if len(name.split()) > 1 else '',
                phone=phone or '',
                grade=grade or 'D'
            )
            messages.success(request, 'Registration completed successfully! You can now log in.')
            return redirect('login')
        except Exception as e:
            messages.error(request, f'Registration failed: {str(e)}')
    
    return render(request, 'register.html')

def my_courses(request):
    if not request.user.is_authenticated:
        return redirect('login')
    
    context = {
        'user': request.user,
        'current_courses': [
            {'title': 'Office Course', 'progress': 75, 'instructor': 'Prof. Kim', 'total_lessons': 20, 'completed_lessons': 15},
            {'title': 'Excel Course', 'progress': 45, 'instructor': 'Prof. Lee', 'total_lessons': 16, 'completed_lessons': 7},
        ],
        'completed_courses': [
            {'title': 'PowerPoint Course', 'completion_date': '2025-10-15', 'score': 95, 'certificate': True},
            {'title': 'HWP Course', 'completion_date': '2025-09-20', 'score': 88, 'certificate': True},
        ]
    }
    return render(request, 'my_courses.html', context)

def logout_view(request):
    from django.contrib.auth import logout
    logout(request)
    messages.success(request, 'Successfully logged out.')
    return redirect('/')

def health_check(request):
    return HttpResponse("OK - MND LMS is running", content_type="text/plain")

def course_registration(request):
    return HttpResponse("Course registration page is under construction.")

def community(request):
    return HttpResponse("Learning community page is under construction.")

def support(request):
    return HttpResponse("Customer support page is under construction.")

# Admin permission check function
def is_admin(user):
    return user.is_authenticated and user.is_staff

@login_required
def admin_dashboard(request):
    # Check if user is admin
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Admin Dashboard"""
    context = {
        'total_users': User.objects.count(),
        'total_courses': Course.objects.count(),
        'total_enrollments': Enrollment.objects.count(),
        'active_courses': Course.objects.filter(status='published').count(),
        'recent_enrollments': Enrollment.objects.select_related('student', 'course').order_by('-enrolled_at')[:10],
        'recent_posts': Post.objects.select_related('author', 'board').order_by('-created_at')[:10],
        'course_stats': Course.objects.values('status').annotate(count=Count('id')),
        'enrollment_stats': Enrollment.objects.values('status').annotate(count=Count('id')),
    }
    return render(request, 'admin/custom_dashboard.html', context)

@login_required
def user_management(request):
    # Check if user is admin
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """User Management"""
    search_query = request.GET.get('search', '')
    grade_filter = request.GET.get('grade', '')
    
    users = User.objects.all()
    
    if search_query:
        users = users.filter(
            Q(username__icontains=search_query) |
            Q(real_name__icontains=search_query) |
            Q(email__icontains=search_query)
        )
    
    if grade_filter:
        users = users.filter(grade=grade_filter)
    
    users = users.order_by('-date_joined')
    paginator = Paginator(users, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'search_query': search_query,
        'grade_filter': grade_filter,
        'grade_choices': User.GRADE_CHOICES,
    }
    return render(request, 'admin/user_management.html', context)

@login_required
def user_detail(request, user_id):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """User Detail Information"""
    user = get_object_or_404(User, id=user_id)
    enrollments = Enrollment.objects.filter(student=user).select_related('course')
    
    context = {
        'user_obj': user,
        'enrollments': enrollments,
    }
    return render(request, 'admin/user_detail.html', context)

@login_required
def reset_password(request, user_id):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Password Reset"""
    if request.method == 'POST':
        user = get_object_or_404(User, id=user_id)
        new_password = 'temp123!'  # 임시 비밀번호
        user.set_password(new_password)
        user.save()
        
        messages.success(request, f'{user.username} password has been reset. New password: {new_password}')
        return redirect('user_detail', user_id=user_id)
    
    return redirect('user_management')

@login_required
def course_management(request):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Course Management"""
    search_query = request.GET.get('search', '')
    category_filter = request.GET.get('category', '')
    status_filter = request.GET.get('status', '')
    
    courses = Course.objects.select_related('category')
    
    if search_query:
        courses = courses.filter(
            Q(title__icontains=search_query) |
            Q(instructor__icontains=search_query)
        )
    
    if category_filter:
        courses = courses.filter(category_id=category_filter)
    
    if status_filter:
        courses = courses.filter(status=status_filter)
    
    courses = courses.order_by('-created_at')
    paginator = Paginator(courses, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'search_query': search_query,
        'category_filter': category_filter,
        'status_filter': status_filter,
        'categories': CourseCategory.objects.filter(is_active=True),
        'status_choices': Course.STATUS_CHOICES,
    }
    return render(request, 'admin/course_management.html', context)

@login_required
def board_management(request):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Board Management"""
    boards = Board.objects.annotate(post_count=Count('post')).order_by('order')
    
    if request.method == 'POST':
        action = request.POST.get('action')
        
        if action == 'create':
            name = request.POST.get('name')
            board_type = request.POST.get('board_type')
            description = request.POST.get('description', '')
            
            if name and board_type:
                Board.objects.create(
                    name=name,
                    board_type=board_type,
                    description=description,
                    order=boards.count() + 1
                )
                messages.success(request, 'Board has been created successfully.')
        
        return redirect('board_management')
    
    context = {
        'boards': boards,
        'board_type_choices': Board.BOARD_TYPE_CHOICES,
    }
    return render(request, 'admin/board_management.html', context)

@login_required
def post_management(request, board_id=None):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Post Management"""
    boards = Board.objects.filter(is_active=True)
    posts = Post.objects.select_related('author', 'board')
    
    if board_id:
        posts = posts.filter(board_id=board_id)
        current_board = get_object_or_404(Board, id=board_id)
    else:
        current_board = None
    
    search_query = request.GET.get('search', '')
    if search_query:
        posts = posts.filter(
            Q(title__icontains=search_query) |
            Q(content__icontains=search_query) |
            Q(author__username__icontains=search_query)
        )
    
    posts = posts.order_by('-created_at')
    paginator = Paginator(posts, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'boards': boards,
        'current_board': current_board,
        'search_query': search_query,
    }
    return render(request, 'admin/post_management.html', context)

@login_required
def site_settings(request):
    if not request.user.is_staff:
        messages.error(request, 'Access denied. Admin privileges required.')
        return redirect('home')
    """Site Settings"""
    settings_obj, created = SiteSettings.objects.get_or_create()
    
    if request.method == 'POST':
        settings_obj.site_name = request.POST.get('site_name', settings_obj.site_name)
        settings_obj.site_description = request.POST.get('site_description', settings_obj.site_description)
        settings_obj.admin_email = request.POST.get('admin_email', settings_obj.admin_email)
        settings_obj.phone = request.POST.get('phone', settings_obj.phone)
        settings_obj.address = request.POST.get('address', settings_obj.address)
        settings_obj.hero_title = request.POST.get('hero_title', settings_obj.hero_title)
        settings_obj.hero_subtitle = request.POST.get('hero_subtitle', settings_obj.hero_subtitle)
        settings_obj.allow_registration = 'allow_registration' in request.POST
        settings_obj.email_verification = 'email_verification' in request.POST
        settings_obj.maintenance_mode = 'maintenance_mode' in request.POST
        
        settings_obj.save()
        messages.success(request, 'Site settings have been saved successfully.')
        return redirect('site_settings')
    
    context = {
        'settings': settings_obj,
    }
    return render(request, 'admin/site_settings.html', context)
