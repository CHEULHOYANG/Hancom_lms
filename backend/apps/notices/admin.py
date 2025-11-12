# -*- coding: utf-8 -*-
"""
Notices app admin configuration
"""
from django.contrib import admin
from .models import Notice, NoticeReadStatus


@admin.register(Notice)
class NoticeAdmin(admin.ModelAdmin):
    """Notice admin configuration"""
    
    list_display = ['title', 'author', 'notice_type', 'is_published', 'is_pinned', 'published_at', 'view_count']
    list_filter = ['notice_type', 'is_published', 'is_pinned', 'show_on_main', 'published_at']
    search_fields = ['title', 'content', 'author__username']
    ordering = ['-is_pinned', '-published_at', '-created_at']
    
    fieldsets = (
        ('Basic Info', {
            'fields': ('title', 'content', 'author', 'notice_type')
        }),
        ('Visibility', {
            'fields': ('is_published', 'is_pinned', 'show_on_main', 'published_at')
        }),
        ('Attachment', {
            'fields': ('attachment',)
        }),
        ('Statistics', {
            'fields': ('view_count',),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['view_count']


@admin.register(NoticeReadStatus)
class NoticeReadStatusAdmin(admin.ModelAdmin):
    """Notice read status admin configuration"""
    
    list_display = ['notice', 'user', 'read_at']
    list_filter = ['notice', 'read_at']
    search_fields = ['notice__title', 'user__username']
    ordering = ['-read_at']