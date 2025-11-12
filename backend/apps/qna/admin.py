# -*- coding: utf-8 -*-
"""
Q&A app admin configuration
"""
from django.contrib import admin
from .models import Question, Answer, QnaCategory


@admin.register(QnaCategory)
class QnaCategoryAdmin(admin.ModelAdmin):
    """Q&A category admin configuration"""
    
    list_display = ['name', 'parent', 'sort_order', 'is_active']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'description']
    ordering = ['sort_order', 'name']


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    """Question admin configuration"""
    
    list_display = ['title', 'user', 'course', 'category', 'status', 'priority', 'created_at']
    list_filter = ['status', 'category', 'priority', 'is_public', 'is_faq', 'created_at']
    search_fields = ['title', 'content', 'user__username']
    ordering = ['-created_at']
    
    fieldsets = (
        ('Basic Info', {
            'fields': ('title', 'content', 'user', 'course')
        }),
        ('Classification', {
            'fields': ('category', 'priority', 'status')
        }),
        ('Visibility', {
            'fields': ('is_public', 'is_faq')
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


@admin.register(Answer)
class AnswerAdmin(admin.ModelAdmin):
    """Answer admin configuration"""
    
    list_display = ['question', 'user', 'is_staff_answer', 'is_accepted', 'created_at']
    list_filter = ['is_staff_answer', 'is_accepted', 'created_at']
    search_fields = ['content', 'question__title', 'user__username']
    ordering = ['-created_at']
    
    fieldsets = (
        ('Answer Info', {
            'fields': ('question', 'content', 'user')
        }),
        ('Status', {
            'fields': ('is_staff_answer', 'is_accepted')
        }),
        ('Attachment', {
            'fields': ('attachment',)
        }),
    )