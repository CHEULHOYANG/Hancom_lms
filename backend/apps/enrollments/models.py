# -*- coding: utf-8 -*-
"""
Enrollment management models
"""
from django.db import models
from django.contrib.auth import get_user_model
from apps.common.models import BaseModel
from apps.courses.models import Course, Lesson

User = get_user_model()


class Enrollment(BaseModel):
    """Student enrollment in courses"""
    
    student = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='enrollments',
        verbose_name="Student"
    )
    course = models.ForeignKey(
        Course,
        on_delete=models.CASCADE,
        related_name='enrollments',
        verbose_name="Course"
    )
    
    # Enrollment Status
    status = models.CharField(
        max_length=20,
        choices=[
            ('active', 'Active'),
            ('completed', 'Completed'),
            ('suspended', 'Suspended'),
            ('cancelled', 'Cancelled'),
        ],
        default='active',
        verbose_name="Status"
    )
    
    # Progress Tracking
    progress_percentage = models.DecimalField(
        max_digits=5, 
        decimal_places=2, 
        default=0,
        verbose_name="Progress Percentage"
    )
    
    # Timestamps
    enrolled_at = models.DateTimeField(auto_now_add=True, verbose_name="Enrolled At")
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name="Completed At")
    last_accessed_at = models.DateTimeField(null=True, blank=True, verbose_name="Last Accessed At")
    
    # Certificate
    certificate_issued = models.BooleanField(default=False, verbose_name="Certificate Issued")
    certificate_issued_at = models.DateTimeField(null=True, blank=True, verbose_name="Certificate Issued At")
    
    class Meta:
        verbose_name = "Enrollment"
        verbose_name_plural = "Enrollments"
        unique_together = ['student', 'course']
        ordering = ['-enrolled_at']
    
    def __str__(self):
        return f"{self.student.username} - {self.course.title}"


class LessonProgress(BaseModel):
    """Individual lesson progress tracking"""
    
    enrollment = models.ForeignKey(
        Enrollment,
        on_delete=models.CASCADE,
        related_name='lesson_progress',
        verbose_name="Enrollment"
    )
    lesson = models.ForeignKey(
        Lesson,
        on_delete=models.CASCADE,
        related_name='student_progress',
        verbose_name="Lesson"
    )
    
    # Progress Data
    is_completed = models.BooleanField(default=False, verbose_name="Is Completed")
    completion_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0,
        verbose_name="Completion Percentage"
    )
    watch_time = models.PositiveIntegerField(default=0, verbose_name="Watch Time (seconds)")
    
    # Timestamps
    first_accessed_at = models.DateTimeField(null=True, blank=True, verbose_name="First Accessed At")
    last_accessed_at = models.DateTimeField(null=True, blank=True, verbose_name="Last Accessed At")
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name="Completed At")
    
    class Meta:
        verbose_name = "Lesson Progress"
        verbose_name_plural = "Lesson Progress"
        unique_together = ['enrollment', 'lesson']
        ordering = ['lesson__sort_order']
    
    def __str__(self):
        return f"{self.enrollment.student.username} - {self.lesson.title}"


class StudySession(BaseModel):
    """Study session tracking"""
    
    enrollment = models.ForeignKey(
        Enrollment,
        on_delete=models.CASCADE,
        related_name='study_sessions',
        verbose_name="Enrollment"
    )
    lesson = models.ForeignKey(
        Lesson,
        on_delete=models.CASCADE,
        related_name='study_sessions',
        verbose_name="Lesson"
    )
    
    # Session Data
    start_time = models.DateTimeField(verbose_name="Start Time")
    end_time = models.DateTimeField(null=True, blank=True, verbose_name="End Time")
    duration = models.PositiveIntegerField(default=0, verbose_name="Duration (seconds)")
    
    # Video Progress (for video lessons)
    video_position = models.PositiveIntegerField(default=0, verbose_name="Video Position (seconds)")
    
    class Meta:
        verbose_name = "Study Session"
        verbose_name_plural = "Study Sessions"
        ordering = ['-start_time']
    
    def __str__(self):
        return f"{self.enrollment.student.username} - {self.lesson.title} ({self.start_time})"