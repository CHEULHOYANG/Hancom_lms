# -*- coding: utf-8 -*-
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone


class CourseCategory(models.Model):
    """강의 카테고리"""
    
    name = models.CharField('카테고리명', max_length=100)
    description = models.TextField('설명', blank=True)
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, 
                              verbose_name='상위 카테고리', related_name='children')
    order = models.PositiveIntegerField('정렬순서', default=0)
    is_active = models.BooleanField('활성화', default=True)
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '강의 카테고리'
        verbose_name_plural = '강의 카테고리'
        db_table = 'course_category'
        ordering = ['order', 'name']
    
    def __str__(self):
        return self.name


class Course(models.Model):
    """강의"""
    
    STATUS_CHOICES = [
        ('active', '활성'),
        ('inactive', '비활성'),
        ('draft', '임시저장'),
    ]
    
    LEVEL_CHOICES = [
        ('beginner', '초급'),
        ('intermediate', '중급'),
        ('advanced', '고급'),
    ]
    
    title = models.CharField('강의명', max_length=200)
    subtitle = models.CharField('부제목', max_length=300, blank=True)
    description = models.TextField('강의 설명')
    category = models.ForeignKey(CourseCategory, on_delete=models.PROTECT, verbose_name='카테고리')
    instructor = models.ForeignKey('authentication.User', on_delete=models.PROTECT, 
                                 verbose_name='강사', related_name='taught_courses')
    
    # Course details
    level = models.CharField('난이도', max_length=20, choices=LEVEL_CHOICES, default='beginner')
    duration_weeks = models.PositiveIntegerField('수강 기간(주)', default=4)
    estimated_hours = models.PositiveIntegerField('예상 학습시간(시간)', default=10)
    
    # Media
    thumbnail = models.ImageField('썸네일', upload_to='course_thumbnails/', null=True, blank=True)
    preview_video = models.URLField('미리보기 영상 URL', blank=True)
    
    # Pricing
    price = models.DecimalField('가격', max_digits=10, decimal_places=2, default=0)
    is_free = models.BooleanField('무료 강의', default=False)
    discount_price = models.DecimalField('할인가격', max_digits=10, decimal_places=2, null=True, blank=True)
    
    # Enrollment
    max_students = models.PositiveIntegerField('최대 수강생', null=True, blank=True)
    enrollment_start = models.DateTimeField('수강신청 시작일', null=True, blank=True)
    enrollment_end = models.DateTimeField('수강신청 마감일', null=True, blank=True)
    
    # Course dates
    start_date = models.DateTimeField('강의 시작일', null=True, blank=True)
    end_date = models.DateTimeField('강의 종료일', null=True, blank=True)
    
    # Status
    status = models.CharField('상태', max_length=20, choices=STATUS_CHOICES, default='draft')
    is_featured = models.BooleanField('추천 강의', default=False)
    
    # Statistics
    view_count = models.PositiveIntegerField('조회수', default=0)
    enrollment_count = models.PositiveIntegerField('수강생수', default=0)
    
    # SEO
    slug = models.SlugField('URL 슬러그', unique=True)
    meta_description = models.TextField('메타 설명', blank=True)
    
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '강의'
        verbose_name_plural = '강의'
        db_table = 'course'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title
    
    @property
    def current_price(self):
        """현재 가격 (할인가격이 있으면 할인가격, 없으면 정가)"""
        return self.discount_price if self.discount_price else self.price
    
    @property
    def is_enrollable(self):
        """수강신청 가능 여부"""
        now = timezone.now()
        if self.enrollment_start and now < self.enrollment_start:
            return False
        if self.enrollment_end and now > self.enrollment_end:
            return False
        if self.max_students and self.enrollment_count >= self.max_students:
            return False
        return self.status == 'active'


class CourseSection(models.Model):
    """강의 섹션"""
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE, verbose_name='강의', related_name='sections')
    title = models.CharField('섹션명', max_length=200)
    description = models.TextField('섹션 설명', blank=True)
    order = models.PositiveIntegerField('정렬순서', default=0)
    is_active = models.BooleanField('활성화', default=True)
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '강의 섹션'
        verbose_name_plural = '강의 섹션'
        db_table = 'course_section'
        ordering = ['course', 'order']
    
    def __str__(self):
        return f"{self.course.title} - {self.title}"


class Lesson(models.Model):
    """레슨"""
    
    LESSON_TYPES = [
        ('video', '동영상'),
        ('text', '텍스트'),
        ('quiz', '퀴즈'),
        ('assignment', '과제'),
    ]
    
    section = models.ForeignKey(CourseSection, on_delete=models.CASCADE, verbose_name='섹션', related_name='lessons')
    title = models.CharField('레슨명', max_length=200)
    content = models.TextField('내용', blank=True)
    lesson_type = models.CharField('레슨 유형', max_length=20, choices=LESSON_TYPES, default='video')
    
    # Video content
    video_url = models.URLField('동영상 URL', blank=True)
    video_duration = models.PositiveIntegerField('동영상 길이(초)', null=True, blank=True)
    
    # File attachments
    attachments = models.FileField('첨부파일', upload_to='lesson_attachments/', null=True, blank=True)
    
    # Settings
    is_preview = models.BooleanField('미리보기 가능', default=False)
    is_required = models.BooleanField('필수 레슨', default=True)
    order = models.PositiveIntegerField('정렬순서', default=0)
    
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '레슨'
        verbose_name_plural = '레슨'
        db_table = 'lesson'
        ordering = ['section', 'order']
    
    def __str__(self):
        return f"{self.section.course.title} - {self.section.title} - {self.title}"


class CourseReview(models.Model):
    """강의 리뷰"""
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE, verbose_name='강의', related_name='reviews')
    user = models.ForeignKey('authentication.User', on_delete=models.CASCADE, 
                           verbose_name='작성자', related_name='course_reviews')
    rating = models.PositiveIntegerField('평점')  # 1-5
    title = models.CharField('제목', max_length=200)
    content = models.TextField('내용')
    is_recommended = models.BooleanField('추천 여부', default=True)
    
    # Moderation
    is_approved = models.BooleanField('승인 여부', default=True)
    
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '강의 리뷰'
        verbose_name_plural = '강의 리뷰'
        db_table = 'course_review'
        ordering = ['-created_at']
        unique_together = ['course', 'user']  # 한 사용자당 한 강의에 하나의 리뷰만
    
    def __str__(self):
        return f"{self.course.title} - {self.user.username} ({self.rating}점)"


class CourseFAQ(models.Model):
    """강의 FAQ"""
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE, verbose_name='강의', related_name='faqs')
    question = models.CharField('질문', max_length=300)
    answer = models.TextField('답변')
    order = models.PositiveIntegerField('정렬순서', default=0)
    is_active = models.BooleanField('활성화', default=True)
    
    created_at = models.DateTimeField('생성일시', auto_now_add=True)
    updated_at = models.DateTimeField('수정일시', auto_now=True)
    
    class Meta:
        verbose_name = '강의 FAQ'
        verbose_name_plural = '강의 FAQ'
        db_table = 'course_faq'
        ordering = ['course', 'order']
    
    def __str__(self):
        return f"{self.course.title} - {self.question[:50]}"