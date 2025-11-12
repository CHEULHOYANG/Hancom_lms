# -*- coding: utf-8 -*-
"""
Course management models
"""
from django.db import models
from django.contrib.auth import get_user_model
from apps.common.models import BaseModel

User = get_user_model()


class CourseCategory(BaseModel):
    """Course category model"""
    
    name = models.CharField(max_length=100, verbose_name="Category Name")
    description = models.TextField(blank=True, verbose_name="Description")
    parent = models.ForeignKey(
        'self', 
        null=True, 
        blank=True, 
        on_delete=models.CASCADE,
        related_name='children',
        verbose_name="Parent Category"
    )
    sort_order = models.PositiveIntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "과정 카테고리"
        verbose_name_plural = "과정 카테고리"
        ordering = ['sort_order', 'name']
    
    def __str__(self):
        return self.name


class Course(BaseModel):
    """Course model"""
    
    title = models.CharField(max_length=200, verbose_name="Course Title")
    subtitle = models.CharField(max_length=300, blank=True, verbose_name="Subtitle")
    description = models.TextField(verbose_name="Description")
    short_description = models.CharField(max_length=500, blank=True, verbose_name="Short Description")
    
    # Course Details
    category = models.ForeignKey(
        CourseCategory, 
        on_delete=models.PROTECT,
        related_name='courses',
        verbose_name="Category"
    )
    instructor = models.ForeignKey(
        User, 
        on_delete=models.PROTECT,
        related_name='taught_courses',
        verbose_name="Instructor"
    )
    
    # Media
    thumbnail = models.ImageField(upload_to='course_thumbnails/', blank=True, null=True)
    preview_video = models.URLField(blank=True, verbose_name="Preview Video URL")
    
    # 국방부 LMS는 모든 강의가 무료입니다
    
    # Course Settings
    is_published = models.BooleanField(default=False, verbose_name="Is Published")
    is_featured = models.BooleanField(default=False, verbose_name="Is Featured")
    difficulty_level = models.CharField(
        max_length=20,
        choices=[
            ('beginner', 'Beginner'),
            ('intermediate', 'Intermediate'),
            ('advanced', 'Advanced'),
        ],
        default='beginner',
        verbose_name="Difficulty Level"
    )
    
    # Duration and Requirements
    estimated_hours = models.PositiveIntegerField(default=0, verbose_name="Estimated Hours")
    prerequisites = models.TextField(blank=True, verbose_name="Prerequisites")
    learning_objectives = models.TextField(blank=True, verbose_name="Learning Objectives")
    
    # Stats
    enrollment_count = models.PositiveIntegerField(default=0, verbose_name="Enrollment Count")
    average_rating = models.DecimalField(max_digits=3, decimal_places=2, default=0, verbose_name="Average Rating")
    total_reviews = models.PositiveIntegerField(default=0, verbose_name="Total Reviews")
    
    class Meta:
        verbose_name = "과정"
        verbose_name_plural = "과정"
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title


class CourseSection(BaseModel):
    """Course section model"""
    
    course = models.ForeignKey(
        Course,
        on_delete=models.CASCADE,
        related_name='sections',
        verbose_name="Course"
    )
    title = models.CharField(max_length=200, verbose_name="Section Title")
    description = models.TextField(blank=True, verbose_name="Description")
    sort_order = models.PositiveIntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "과정 섹션"
        verbose_name_plural = "과정 섹션"
        ordering = ['course', 'sort_order']
    
    def __str__(self):
        return f"{self.course.title} - {self.title}"


class Lesson(BaseModel):
    """Lesson model"""
    
    section = models.ForeignKey(
        CourseSection,
        on_delete=models.CASCADE,
        related_name='lessons',
        verbose_name="Section"
    )
    title = models.CharField(max_length=200, verbose_name="Lesson Title")
    content = models.TextField(blank=True, verbose_name="Content")
    
    # Media
    video_url = models.URLField(blank=True, verbose_name="Video URL")
    video_duration = models.PositiveIntegerField(default=0, verbose_name="Video Duration (seconds)")
    
    # Lesson Type
    lesson_type = models.CharField(
        max_length=20,
        choices=[
            ('video', 'Video'),
            ('text', 'Text'),
            ('quiz', 'Quiz'),
            ('assignment', 'Assignment'),
        ],
        default='video',
        verbose_name="Lesson Type"
    )
    
    # Settings
    is_preview = models.BooleanField(default=False, verbose_name="Is Preview")
    sort_order = models.PositiveIntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "레슨"
        verbose_name_plural = "레슨"
        ordering = ['section', 'sort_order']
    
    def __str__(self):
        return f"{self.section.title} - {self.title}"


class CourseReview(BaseModel):
    """Course review model"""
    
    course = models.ForeignKey(
        Course,
        on_delete=models.CASCADE,
        related_name='reviews',
        verbose_name="Course"
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='course_reviews',
        verbose_name="User"
    )
    rating = models.PositiveSmallIntegerField(
        choices=[(i, i) for i in range(1, 6)],
        verbose_name="Rating"
    )
    title = models.CharField(max_length=200, blank=True, verbose_name="Review Title")
    content = models.TextField(verbose_name="Review Content")
    
    class Meta:
        verbose_name = "과정 리뷰"
        verbose_name_plural = "과정 리뷰"
        unique_together = ['course', 'user']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.course.title} - {self.user.username} ({self.rating}/5)"