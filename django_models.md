# Django Models Implementation

## Authentication Models

```python
# authentication/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.core.validators import RegexValidator
import argon2
import jwt
from datetime import datetime, timedelta
from django.conf import settings

class User(AbstractUser):
    ROLE_CHOICES = [
        ('student', '학생'),
        ('instructor', '강사'),
        ('admin', '관리자'),
    ]
    
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='student')
    phone = models.CharField(
        max_length=20, 
        blank=True,
        validators=[RegexValidator(r'^\d{2,3}-\d{3,4}-\d{4}$', '올바른 전화번호 형식이 아닙니다.')]
    )
    birth_date = models.DateField(null=True, blank=True)
    profile_image = models.ImageField(upload_to='profiles/', blank=True)
    
    # Security fields
    failed_login_attempts = models.IntegerField(default=0)
    account_locked_until = models.DateTimeField(null=True, blank=True)
    last_password_change = models.DateTimeField(auto_now_add=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def set_password(self, raw_password):
        """Override to use Argon2"""
        ph = argon2.PasswordHasher(
            time_cost=3,
            memory_cost=65536,
            parallelism=1,
            hash_len=32,
            salt_len=16
        )
        self.password = ph.hash(raw_password)
        self.last_password_change = datetime.now()
    
    def check_password(self, raw_password):
        """Override to use Argon2"""
        try:
            ph = argon2.PasswordHasher()
            ph.verify(self.password, raw_password)
            return True
        except argon2.exceptions.VerifyMismatchError:
            return False
    
    def generate_jwt_tokens(self):
        """Generate JWT access and refresh tokens"""
        now = datetime.utcnow()
        
        access_payload = {
            'user_id': self.id,
            'username': self.username,
            'role': self.role,
            'exp': now + timedelta(minutes=15),
            'iat': now,
            'type': 'access'
        }
        
        refresh_payload = {
            'user_id': self.id,
            'exp': now + timedelta(days=7),
            'iat': now,
            'type': 'refresh'
        }
        
        access_token = jwt.encode(access_payload, settings.SECRET_KEY, algorithm='HS256')
        refresh_token = jwt.encode(refresh_payload, settings.SECRET_KEY, algorithm='HS256')
        
        # Store refresh token in cache for blacklist capability
        from django.core.cache import cache
        cache.set(f"refresh:{self.id}:{refresh_token}", True, timeout=7*24*3600)
        
        return access_token, refresh_token
    
    def is_account_locked(self):
        """Check if account is locked"""
        if self.account_locked_until:
            return datetime.now() < self.account_locked_until
        return False
    
    def lock_account(self, duration_minutes=30):
        """Lock account for specified duration"""
        self.account_locked_until = datetime.now() + timedelta(minutes=duration_minutes)
        self.save()
    
    def unlock_account(self):
        """Unlock account and reset failed attempts"""
        self.failed_login_attempts = 0
        self.account_locked_until = None
        self.save()
    
    class Meta:
        db_table = 'auth_user'
        verbose_name = '사용자'
        verbose_name_plural = '사용자들'

class BlacklistedToken(models.Model):
    """Store blacklisted JWT tokens"""
    token = models.TextField(unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    blacklisted_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'blacklisted_tokens'
```

## Course Models

```python
# courses/models.py
from django.db import models
from django.contrib.auth import get_user_model
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils.text import slugify
import uuid

User = get_user_model()

class CourseCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    order_index = models.IntegerField(default=0)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['order_index', 'name']
        verbose_name = '강의 카테고리'
        verbose_name_plural = '강의 카테고리들'
    
    def __str__(self):
        return self.name

class CourseQuerySet(models.QuerySet):
    def published(self):
        return self.filter(is_published=True)
    
    def by_category(self, category):
        return self.filter(category=category)
    
    def search(self, query):
        return self.filter(
            models.Q(title__icontains=query) |
            models.Q(description__icontains=query)
        )
    
    def for_user_role(self, user):
        if user.role == 'admin':
            return self.all()
        elif user.role == 'instructor':
            return self.filter(instructor=user)
        else:
            return self.published()

class Course(models.Model):
    DIFFICULTY_CHOICES = [
        ('beginner', '초급'),
        ('intermediate', '중급'),
        ('advanced', '고급'),
    ]
    
    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255, unique=True, blank=True)
    description = models.TextField()
    detailed_description = models.TextField(blank=True)
    
    instructor = models.ForeignKey(User, on_delete=models.PROTECT, related_name='taught_courses')
    category = models.ForeignKey(CourseCategory, on_delete=models.SET_NULL, null=True, blank=True)
    
    # Pricing
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    original_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    # Course metadata
    duration_hours = models.IntegerField(default=0)
    difficulty_level = models.CharField(max_length=20, choices=DIFFICULTY_CHOICES, default='beginner')
    language = models.CharField(max_length=10, default='ko')
    
    # Media
    thumbnail = models.ImageField(upload_to='course_thumbnails/', blank=True)
    preview_video = models.URLField(blank=True)
    
    # Content
    prerequisites = models.TextField(blank=True)
    learning_objectives = models.JSONField(default=list)
    tags = models.JSONField(default=list)
    
    # Status
    is_published = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    order_index = models.IntegerField(default=0)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    objects = CourseQuerySet.as_manager()
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)
    
    @property
    def is_free(self):
        return self.price == 0
    
    @property
    def sections_count(self):
        return self.sections.count()
    
    @property
    def total_lessons(self):
        return sum(section.lessons.count() for section in self.sections.all())
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = '강의'
        verbose_name_plural = '강의들'
    
    def __str__(self):
        return self.title

class CourseSection(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='sections')
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    order_index = models.IntegerField()
    is_free = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['order_index']
        unique_together = ['course', 'order_index']
        verbose_name = '강의 섹션'
        verbose_name_plural = '강의 섹션들'
    
    def __str__(self):
        return f"{self.course.title} - {self.title}"

class Lesson(models.Model):
    CONTENT_TYPE_CHOICES = [
        ('video', '비디오'),
        ('text', '텍스트'),
        ('quiz', '퀴즈'),
        ('file', '파일'),
    ]
    
    section = models.ForeignKey(CourseSection, on_delete=models.CASCADE, related_name='lessons')
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    
    # Content
    content_type = models.CharField(max_length=20, choices=CONTENT_TYPE_CHOICES, default='video')
    video_url = models.URLField(blank=True)
    video_duration = models.IntegerField(default=0, help_text='Duration in seconds')
    content = models.TextField(blank=True)
    attachments = models.JSONField(default=list)
    
    order_index = models.IntegerField()
    is_free = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['order_index']
        unique_together = ['section', 'order_index']
        verbose_name = '레슨'
        verbose_name_plural = '레슨들'
    
    def __str__(self):
        return f"{self.section.title} - {self.title}"
```

## Enrollment Models

```python
# enrollments/models.py
from django.db import models
from django.contrib.auth import get_user_model
from courses.models import Course, Lesson
from django.core.validators import MinValueValidator, MaxValueValidator

User = get_user_model()

class Enrollment(models.Model):
    STATUS_CHOICES = [
        ('active', '활성'),
        ('expired', '만료'),
        ('suspended', '정지'),
        ('completed', '완료'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='enrollments')
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='enrollments')
    
    enrollment_date = models.DateTimeField(auto_now_add=True)
    expiry_date = models.DateTimeField(null=True, blank=True)
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')
    progress = models.DecimalField(
        max_digits=5, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)]
    )
    completion_date = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        unique_together = ['user', 'course']
        verbose_name = '수강 신청'
        verbose_name_plural = '수강 신청들'
    
    def __str__(self):
        return f"{self.user.username} - {self.course.title}"
    
    def calculate_progress(self):
        """Calculate course progress based on completed lessons"""
        total_lessons = self.course.total_lessons
        if total_lessons == 0:
            return 0
        
        completed_lessons = LessonProgress.objects.filter(
            user=self.user,
            lesson__section__course=self.course,
            is_completed=True
        ).count()
        
        return (completed_lessons / total_lessons) * 100
    
    def update_progress(self):
        """Update progress and save"""
        self.progress = self.calculate_progress()
        if self.progress >= 100:
            self.status = 'completed'
            if not self.completion_date:
                self.completion_date = timezone.now()
        self.save()

class LessonProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE)
    
    watch_time = models.IntegerField(default=0, help_text='Watch time in seconds')
    completion_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)]
    )
    is_completed = models.BooleanField(default=False)
    last_watched_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'lesson']
        verbose_name = '레슨 진도'
        verbose_name_plural = '레슨 진도들'
    
    def __str__(self):
        return f"{self.user.username} - {self.lesson.title} ({self.completion_percentage}%)"
    
    def save(self, *args, **kwargs):
        # Auto-complete if watch time is sufficient
        if self.lesson.video_duration > 0:
            completion_threshold = 0.9  # 90% completion threshold
            if self.watch_time >= self.lesson.video_duration * completion_threshold:
                self.completion_percentage = 100
                self.is_completed = True
        
        super().save(*args, **kwargs)
        
        # Update enrollment progress
        try:
            enrollment = Enrollment.objects.get(
                user=self.user, 
                course=self.lesson.section.course
            )
            enrollment.update_progress()
        except Enrollment.DoesNotExist:
            pass
```

## Payment Models

```python
# payments/models.py
from django.db import models
from django.contrib.auth import get_user_model
from courses.models import Course
import uuid

User = get_user_model()

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending', '대기중'),
        ('paid', '결제완료'),
        ('failed', '결제실패'),
        ('cancelled', '취소'),
        ('refunded', '환불'),
    ]
    
    PAYMENT_METHOD_CHOICES = [
        ('card', '신용카드'),
        ('bank_transfer', '무통장입금'),
        ('free', '무료'),
    ]
    
    order_number = models.CharField(max_length=50, unique=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='orders')
    
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    discount_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    final_amount = models.DecimalField(max_digits=10, decimal_places=2)
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    payment_method = models.CharField(max_length=20, choices=PAYMENT_METHOD_CHOICES, null=True, blank=True)
    payment_data = models.JSONField(default=dict)
    
    created_at = models.DateTimeField(auto_now_add=True)
    paid_at = models.DateTimeField(null=True, blank=True)
    
    def save(self, *args, **kwargs):
        if not self.order_number:
            self.order_number = self.generate_order_number()
        super().save(*args, **kwargs)
    
    def generate_order_number(self):
        """Generate unique order number"""
        from datetime import datetime
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        return f"ORD{timestamp}{str(uuid.uuid4())[:8].upper()}"
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = '주문'
        verbose_name_plural = '주문들'
    
    def __str__(self):
        return f"{self.order_number} - {self.user.username}"

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField(default=1)
    
    class Meta:
        verbose_name = '주문 항목'
        verbose_name_plural = '주문 항목들'
    
    def __str__(self):
        return f"{self.order.order_number} - {self.course.title}"

class PaymentTransaction(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='transactions')
    transaction_id = models.CharField(max_length=100, blank=True)
    payment_gateway = models.CharField(max_length=50, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20)
    gateway_response = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name = '결제 거래'
        verbose_name_plural = '결제 거래들'
    
    def __str__(self):
        return f"{self.order.order_number} - {self.transaction_id}"
```

This provides the core Django models with proper relationships, validation, and security considerations. Each model includes appropriate meta information and helper methods for business logic.