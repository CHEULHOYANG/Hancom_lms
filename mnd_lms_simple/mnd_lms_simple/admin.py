# -*- coding: utf-8 -*-
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.html import format_html
from django.shortcuts import redirect
from django.urls import path
from django.http import HttpResponse
from .models import CustomUser, CourseCategory, Course, Enrollment, Board, Post, SiteSettings

# Admin site settings
admin.site.site_header = "MND Learning Management System"
admin.site.site_title = "MND LMS Admin"
admin.site.index_title = "Admin Dashboard"

class CustomUserAdmin(UserAdmin):
    """User Management"""
    list_display = ('username', 'get_masked_name', 'get_masked_email', 'get_masked_phone', 
                    'grade', 'login_count', 'get_study_hours', 'is_active')
    list_filter = ('grade', 'is_active', 'is_staff', 'date_joined')
    search_fields = ('username', 'real_name', 'email')
    list_per_page = 20
    
    fieldsets = UserAdmin.fieldsets + (
        ('Additional Info', {
            'fields': ('real_name', 'phone', 'grade', 'login_count', 'total_study_time', 'last_login_ip')
        }),
    )
    
    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Additional Info', {
            'fields': ('real_name', 'phone', 'grade')
        }),
    )
    
    def get_masked_name(self, obj):
        return obj.get_masked_name()
    get_masked_name.short_description = "Name"
    
    def get_masked_email(self, obj):
        return obj.get_masked_email()
    get_masked_email.short_description = "Email"
    
    def get_masked_phone(self, obj):
        return obj.get_masked_phone()
    get_masked_phone.short_description = "Phone"
    
    def get_study_hours(self, obj):
        hours = obj.total_study_time // 60
        minutes = obj.total_study_time % 60
        return f"{hours}h {minutes}m"
    get_study_hours.short_description = "Study Time"

class CourseCategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'description', 'order', 'is_active', 'created_at')
    list_filter = ('is_active',)
    search_fields = ('name',)
    list_editable = ('order', 'is_active')

class CourseAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'instructor', 'level', 'status', 
                    'get_enrollment_info', 'start_date', 'end_date', 'is_featured')
    list_filter = ('category', 'level', 'status', 'is_featured')
    search_fields = ('title', 'instructor')
    list_editable = ('status', 'is_featured')
    date_hierarchy = 'start_date'
    
    def get_enrollment_info(self, obj):
        rate = obj.get_enrollment_rate()
        color = "green" if rate >= 80 else "orange" if rate >= 50 else "red"
        return format_html(
            '<span style="color: {};">{}/{} ({}%)</span>',
            color, obj.current_students, obj.max_students, rate
        )
    get_enrollment_info.short_description = "Enrollment"

class EnrollmentAdmin(admin.ModelAdmin):
    list_display = ('student', 'course', 'status', 'progress', 'enrolled_at', 'completed_at')
    list_filter = ('status', 'enrolled_at', 'course__category')
    search_fields = ('student__username', 'student__real_name', 'course__title')
    list_editable = ('status', 'progress')
    date_hierarchy = 'enrolled_at'
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('student', 'course')

class BoardAdmin(admin.ModelAdmin):
    list_display = ('name', 'board_type', 'is_active', 'order', 'created_at')
    list_filter = ('board_type', 'is_active')
    search_fields = ('name',)
    list_editable = ('is_active', 'order')

class PostAdmin(admin.ModelAdmin):
    list_display = ('title', 'board', 'author', 'is_notice', 'is_secret', 'views', 'created_at')
    list_filter = ('board', 'is_notice', 'is_secret', 'created_at')
    search_fields = ('title', 'content', 'author__username')
    list_editable = ('is_notice', 'is_secret')
    date_hierarchy = 'created_at'
    
    def get_queryset(self, request):
        return super().get_queryset(request).select_related('board', 'author')

class SiteSettingsAdmin(admin.ModelAdmin):
    list_display = ('site_name', 'admin_email', 'allow_registration', 'maintenance_mode', 'updated_at')
    
    def has_add_permission(self, request):
        # SiteSettings는 하나만 존재해야 함
        return not SiteSettings.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        # SiteSettings는 삭제할 수 없음
        return False

# Register models
admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(CourseCategory, CourseCategoryAdmin)
admin.site.register(Course, CourseAdmin)
admin.site.register(Enrollment, EnrollmentAdmin)
admin.site.register(Board, BoardAdmin)  
admin.site.register(Post, PostAdmin)
admin.site.register(SiteSettings, SiteSettingsAdmin)
