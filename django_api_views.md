# Django API Views Implementation

## Authentication Views

```python
# authentication/views.py
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.utils import timezone
from datetime import datetime, timedelta
import jwt
from django.conf import settings
from django.core.cache import cache
import logging

from .models import User, BlacklistedToken
from .serializers import UserSerializer, LoginSerializer, RegisterSerializer
from common.validators import SecurityValidator
from common.utils import get_client_ip

logger = logging.getLogger('security')

@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    """User login with security measures"""
    serializer = LoginSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    username = serializer.validated_data['username']
    password = serializer.validated_data['password']
    ip_address = get_client_ip(request)
    
    try:
        user = User.objects.get(username=username)
        
        # Check if account is locked
        if user.is_account_locked():
            logger.warning(f"Login attempt on locked account: {username} from {ip_address}")
            return Response(
                {'error': '계정이 잠겨있습니다. 나중에 다시 시도해주세요.'},
                status=status.HTTP_423_LOCKED
            )
        
        # Authenticate user
        if user.check_password(password):
            # Successful login
            user.unlock_account()  # Reset failed attempts
            user.last_login = timezone.now()
            user.save()
            
            # Generate JWT tokens
            access_token, refresh_token = user.generate_jwt_tokens()
            
            # Log successful login
            logger.info(f"Successful login: {username} from {ip_address}")
            
            return Response({
                'access_token': access_token,
                'refresh_token': refresh_token,
                'user': UserSerializer(user).data
            })
        else:
            # Failed login
            user.failed_login_attempts += 1
            if user.failed_login_attempts >= 5:
                user.lock_account(duration_minutes=30)
                logger.warning(f"Account locked due to failed attempts: {username} from {ip_address}")
            user.save()
            
            logger.warning(f"Failed login attempt: {username} from {ip_address}")
            return Response(
                {'error': '아이디 또는 비밀번호가 올바르지 않습니다.'},
                status=status.HTTP_401_UNAUTHORIZED
            )
    
    except User.DoesNotExist:
        logger.warning(f"Login attempt for non-existent user: {username} from {ip_address}")
        return Response(
            {'error': '아이디 또는 비밀번호가 올바르지 않습니다.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """User logout with token blacklisting"""
    try:
        # Extract token from request
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        if auth_header.startswith('Bearer '):
            token = auth_header.split(' ')[1]
            
            # Add token to blacklist
            BlacklistedToken.objects.create(
                token=token,
                user=request.user
            )
            
            logger.info(f"User logged out: {request.user.username}")
            return Response({'message': '로그아웃되었습니다.'})
    
    except Exception as e:
        logger.error(f"Logout error: {str(e)}")
    
    return Response({'message': '로그아웃되었습니다.'})

@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    """User registration with validation"""
    serializer = RegisterSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        # Additional security validation
        SecurityValidator.validate_username(serializer.validated_data['username'])
        
        user = serializer.save()
        
        logger.info(f"New user registered: {user.username}")
        
        return Response({
            'message': '회원가입이 완료되었습니다.',
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)
    
    except Exception as e:
        logger.error(f"Registration error: {str(e)}")
        return Response(
            {'error': '회원가입 중 오류가 발생했습니다.'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['POST'])
@permission_classes([AllowAny])
def refresh_token_view(request):
    """Refresh JWT access token"""
    refresh_token = request.data.get('refresh_token')
    if not refresh_token:
        return Response(
            {'error': 'Refresh token이 필요합니다.'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    try:
        # Decode refresh token
        payload = jwt.decode(refresh_token, settings.SECRET_KEY, algorithms=['HS256'])
        
        if payload.get('type') != 'refresh':
            raise jwt.InvalidTokenError('Invalid token type')
        
        # Check if token is blacklisted
        if cache.get(f"refresh:{payload['user_id']}:{refresh_token}") is None:
            raise jwt.InvalidTokenError('Token is blacklisted')
        
        # Get user and generate new access token
        user = User.objects.get(id=payload['user_id'])
        access_token, _ = user.generate_jwt_tokens()
        
        return Response({'access_token': access_token})
    
    except jwt.ExpiredSignatureError:
        return Response(
            {'error': 'Refresh token이 만료되었습니다.'},
            status=status.HTTP_401_UNAUTHORIZED
        )
    except (jwt.InvalidTokenError, User.DoesNotExist):
        return Response(
            {'error': '유효하지 않은 refresh token입니다.'},
            status=status.HTTP_401_UNAUTHORIZED
        )

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def profile_view(request):
    """Get user profile"""
    serializer = UserSerializer(request.user)
    return Response(serializer.data)
```

## Course Views

```python
# courses/views.py
from rest_framework import generics, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.db.models import Q, Count, Avg
from django.shortcuts import get_object_or_404

from .models import Course, CourseCategory, CourseSection, Lesson
from .serializers import (
    CourseSerializer, CourseDetailSerializer, CourseCategorySerializer,
    CourseSectionSerializer, LessonSerializer
)
from common.permissions import IsInstructorOrAdmin, IsOwnerOrAdmin
from common.pagination import StandardResultsSetPagination

class CourseListView(generics.ListAPIView):
    """List courses with filtering and search"""
    serializer_class = CourseSerializer
    pagination_class = StandardResultsSetPagination
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Course.objects.published().select_related('instructor', 'category')
        
        # Category filter
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category__id=category)
        
        # Search filter
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.search(search)
        
        # Difficulty filter
        difficulty = self.request.query_params.get('difficulty')
        if difficulty:
            queryset = queryset.filter(difficulty_level=difficulty)
        
        # Price filter
        is_free = self.request.query_params.get('is_free')
        if is_free == 'true':
            queryset = queryset.filter(price=0)
        elif is_free == 'false':
            queryset = queryset.filter(price__gt=0)
        
        # Featured courses
        featured = self.request.query_params.get('featured')
        if featured == 'true':
            queryset = queryset.filter(is_featured=True)
        
        return queryset.order_by('-created_at')

class CourseDetailView(generics.RetrieveAPIView):
    """Get course details"""
    serializer_class = CourseDetailSerializer
    permission_classes = [AllowAny]
    lookup_field = 'slug'
    
    def get_queryset(self):
        return Course.objects.published().select_related('instructor', 'category').prefetch_related('sections__lessons')

class CourseSectionListView(generics.ListAPIView):
    """List course sections (requires enrollment for paid courses)"""
    serializer_class = CourseSectionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        course_id = self.kwargs['course_id']
        course = get_object_or_404(Course, id=course_id)
        
        # Check if user has access to this course
        if not course.is_free:
            from enrollments.models import Enrollment
            enrollment = Enrollment.objects.filter(
                user=self.request.user,
                course=course,
                status='active'
            ).first()
            
            if not enrollment:
                self.permission_denied(
                    self.request,
                    message="이 강의에 수강 신청이 필요합니다."
                )
        
        return CourseSection.objects.filter(course=course).prefetch_related('lessons').order_by('order_index')

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def lesson_detail_view(request, lesson_id):
    """Get lesson details with access control"""
    lesson = get_object_or_404(Lesson, id=lesson_id)
    course = lesson.section.course
    
    # Check access permissions
    if not lesson.is_free and not course.is_free:
        from enrollments.models import Enrollment
        enrollment = Enrollment.objects.filter(
            user=request.user,
            course=course,
            status='active'
        ).first()
        
        if not enrollment:
            return Response(
                {'error': '이 레슨에 접근할 권한이 없습니다.'},
                status=status.HTTP_403_FORBIDDEN
            )
    
    # Track lesson progress
    from enrollments.models import LessonProgress
    progress, created = LessonProgress.objects.get_or_create(
        user=request.user,
        lesson=lesson
    )
    
    serializer = LessonSerializer(lesson, context={'request': request})
    data = serializer.data
    data['progress'] = {
        'watch_time': progress.watch_time,
        'completion_percentage': float(progress.completion_percentage),
        'is_completed': progress.is_completed
    }
    
    return Response(data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_lesson_progress(request, lesson_id):
    """Update lesson watching progress"""
    lesson = get_object_or_404(Lesson, id=lesson_id)
    watch_time = request.data.get('watch_time', 0)
    
    try:
        watch_time = int(watch_time)
        if watch_time < 0:
            raise ValueError("Watch time cannot be negative")
    except (ValueError, TypeError):
        return Response(
            {'error': '유효하지 않은 시청 시간입니다.'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    from enrollments.models import LessonProgress
    progress, created = LessonProgress.objects.get_or_create(
        user=request.user,
        lesson=lesson,
        defaults={'watch_time': watch_time}
    )
    
    if not created:
        progress.watch_time = max(progress.watch_time, watch_time)
        progress.save()
    
    return Response({
        'watch_time': progress.watch_time,
        'completion_percentage': float(progress.completion_percentage),
        'is_completed': progress.is_completed
    })

class CourseCategoryListView(generics.ListAPIView):
    """List course categories"""
    serializer_class = CourseCategorySerializer
    permission_classes = [AllowAny]
    queryset = CourseCategory.objects.filter(is_active=True).order_by('order_index')
```

## Enrollment Views

```python
# enrollments/views.py
from rest_framework import generics, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.utils import timezone
from datetime import timedelta

from .models import Enrollment, LessonProgress
from .serializers import EnrollmentSerializer, EnrollmentCreateSerializer
from courses.models import Course
from payments.models import Order, OrderItem

class EnrollmentListView(generics.ListAPIView):
    """List user's enrollments"""
    serializer_class = EnrollmentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Enrollment.objects.filter(user=self.request.user).select_related('course').order_by('-enrollment_date')

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def enroll_course(request):
    """Enroll in a course"""
    serializer = EnrollmentCreateSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    course_id = serializer.validated_data['course_id']
    course = get_object_or_404(Course, id=course_id, is_published=True)
    
    # Check if already enrolled
    existing_enrollment = Enrollment.objects.filter(
        user=request.user,
        course=course
    ).first()
    
    if existing_enrollment:
        return Response(
            {'error': '이미 수강 신청한 강의입니다.'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Free course enrollment
    if course.is_free:
        enrollment = Enrollment.objects.create(
            user=request.user,
            course=course,
            status='active'
        )
        
        return Response(
            EnrollmentSerializer(enrollment).data,
            status=status.HTTP_201_CREATED
        )
    
    # Paid course - need to create order first
    else:
        # Create order
        order = Order.objects.create(
            user=request.user,
            total_amount=course.price,
            final_amount=course.price,
            status='pending'
        )
        
        # Create order item
        OrderItem.objects.create(
            order=order,
            course=course,
            price=course.price
        )
        
        return Response({
            'message': '결제가 필요한 강의입니다.',
            'order_id': order.id,
            'order_number': order.order_number,
            'amount': float(course.price)
        }, status=status.HTTP_202_ACCEPTED)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def enrollment_progress(request, enrollment_id):
    """Get detailed enrollment progress"""
    enrollment = get_object_or_404(
        Enrollment,
        id=enrollment_id,
        user=request.user
    )
    
    # Get lesson progress
    lesson_progresses = LessonProgress.objects.filter(
        user=request.user,
        lesson__section__course=enrollment.course
    ).select_related('lesson__section')
    
    progress_data = []
    for section in enrollment.course.sections.all():
        section_data = {
            'section_id': section.id,
            'section_title': section.title,
            'lessons': []
        }
        
        for lesson in section.lessons.all():
            lesson_progress = lesson_progresses.filter(lesson=lesson).first()
            
            section_data['lessons'].append({
                'lesson_id': lesson.id,
                'lesson_title': lesson.title,
                'duration': lesson.video_duration,
                'watch_time': lesson_progress.watch_time if lesson_progress else 0,
                'completion_percentage': float(lesson_progress.completion_percentage) if lesson_progress else 0,
                'is_completed': lesson_progress.is_completed if lesson_progress else False,
                'last_watched': lesson_progress.last_watched_at if lesson_progress else None
            })
        
        progress_data.append(section_data)
    
    return Response({
        'enrollment': EnrollmentSerializer(enrollment).data,
        'progress_detail': progress_data
    })
```

## Notice Views

```python
# notices/views.py
from rest_framework import generics
from rest_framework.permissions import AllowAny
from django.db.models import F

from .models import Notice
from .serializers import NoticeSerializer, NoticeDetailSerializer
from common.pagination import StandardResultsSetPagination

class NoticeListView(generics.ListAPIView):
    """List notices"""
    serializer_class = NoticeSerializer
    permission_classes = [AllowAny]
    pagination_class = StandardResultsSetPagination
    
    def get_queryset(self):
        return Notice.objects.filter(is_published=True).order_by('-is_important', '-created_at')

class NoticeDetailView(generics.RetrieveAPIView):
    """Get notice detail and increment view count"""
    serializer_class = NoticeDetailSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        return Notice.objects.filter(is_published=True)
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        
        # Increment view count
        Notice.objects.filter(pk=instance.pk).update(views=F('views') + 1)
        
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
```

## Common Utilities

```python
# common/permissions.py
from rest_framework import permissions

class IsInstructorOrAdmin(permissions.BasePermission):
    """Permission for instructors and admins"""
    
    def has_permission(self, request, view):
        return (
            request.user.is_authenticated and
            request.user.role in ['instructor', 'admin']
        )

class IsOwnerOrAdmin(permissions.BasePermission):
    """Permission for object owners and admins"""
    
    def has_object_permission(self, request, view, obj):
        # Admin can access everything
        if request.user.role == 'admin':
            return True
        
        # Check if user owns the object
        if hasattr(obj, 'user'):
            return obj.user == request.user
        elif hasattr(obj, 'instructor'):
            return obj.instructor == request.user
        
        return False

# common/pagination.py
from rest_framework.pagination import PageNumberPagination

class StandardResultsSetPagination(PageNumberPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100

# common/utils.py
def get_client_ip(request):
    """Get client IP address from request"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip
```

This implementation provides secure, well-structured API views with proper authentication, authorization, input validation, and error handling. Each view includes appropriate security measures and follows REST API best practices.