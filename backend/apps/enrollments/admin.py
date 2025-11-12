# -*- coding: utf-8 -*-
"""
Enrollments app admin configuration
"""
from django.contrib import admin
from .models import Enrollment, LessonProgress, StudySession


@admin.register(Enrollment)
class EnrollmentAdmin(admin.ModelAdmin):
    """Enrollment admin configuration"""
    
    list_display = ['student', 'course', 'status', 'progress_percentage', 'enrolled_at']
    list_filter = ['status', 'course', 'enrolled_at', 'certificate_issued']
    search_fields = ['student__username', 'course__title']
    ordering = ['-enrolled_at']
    
    fieldsets = (
        ('Basic Info', {
            'fields': ('student', 'course', 'status')
        }),
        ('Progress', {
            'fields': ('progress_percentage',)
        }),
        ('Timestamps', {
            'fields': ('enrolled_at', 'completed_at', 'last_accessed_at')
        }),
        ('Certificate', {
            'fields': ('certificate_issued', 'certificate_issued_at')
        }),
    )
    
    readonly_fields = ['enrolled_at']


@admin.register(LessonProgress)
class LessonProgressAdmin(admin.ModelAdmin):
    """Lesson progress admin configuration"""
    
    list_display = ['enrollment', 'lesson', 'is_completed', 'completion_percentage', 'watch_time']
    list_filter = ['is_completed', 'lesson__section__course', 'created_at']
    search_fields = ['enrollment__student__username', 'lesson__title']
    ordering = ['-last_accessed_at']


@admin.register(StudySession)
class StudySessionAdmin(admin.ModelAdmin):
    """Study session admin configuration"""
    
    list_display = ['enrollment', 'lesson', 'start_time', 'duration', 'video_position']
    list_filter = ['lesson__section__course', 'start_time']
    search_fields = ['enrollment__student__username', 'lesson__title']
    ordering = ['-start_time']