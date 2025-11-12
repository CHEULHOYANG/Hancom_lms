# -*- coding: utf-8 -*-
"""
Courses app admin configuration
"""
from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from django.utils.safestring import mark_safe
from .models import CourseCategory, Course, CourseSection, Lesson, CourseReview


@admin.register(CourseCategory)
class CourseCategoryAdmin(admin.ModelAdmin):
    """강의 카테고리 관리"""
    
    list_display = ['category_tree', 'name', 'parent', 'course_count', 'sort_order', 'status_display']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'description']
    ordering = ['sort_order', 'name']
    
    fieldsets = (
        ('기본 정보', {
            'fields': ('name', 'description', 'parent', 'sort_order')
        }),
        ('상태', {
            'fields': ('is_active',)
        }),
    )
    
    def category_tree(self, obj):
        """카테고리 트리 구조 표시"""
        if obj.parent:
            return format_html(
                '<span style="margin-left: 20px;">└ {}</span>',
                obj.name
            )
        return format_html('<strong>{}</strong>', obj.name)
    category_tree.short_description = '카테고리 구조'
    
    def course_count(self, obj):
        """해당 카테고리의 강의 수"""
        count = obj.courses.count()
        if count > 0:
            return format_html(
                '<a href="{}?category__id__exact={}">{} 개</a>',
                reverse('admin:courses_course_changelist'),
                obj.id,
                count
            )
        return '0 개'
    course_count.short_description = '강의 수'
    
    def status_display(self, obj):
        """상태 표시"""
        if obj.is_active:
            return format_html(
                '<span style="color: green; font-weight: bold;">활성</span>'
            )
        return format_html(
            '<span style="color: red;">비활성</span>'
        )
    status_display.short_description = '상태'


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    """강의 관리"""
    
    list_display = ['title', 'category', 'instructor', 'thumbnail_display', 'status_display', 'enrollment_count', 'created_at']
    list_filter = ['category', 'difficulty_level', 'is_published', 'is_featured', 'created_at']
    search_fields = ['title', 'subtitle', 'description']
    ordering = ['-created_at']
    
    fieldsets = (
        ('기본 정보', {
            'fields': ('title', 'subtitle', 'description', 'short_description')
        }),
        ('강의 상세', {
            'fields': ('category', 'instructor', 'difficulty_level')
        }),
        ('미디어', {
            'fields': ('thumbnail', 'preview_video')
        }),

        ('설정', {
            'fields': ('is_published', 'is_featured')
        }),
        ('강의 내용', {
            'fields': ('estimated_hours', 'prerequisites', 'learning_objectives')
        }),
        ('통계 (읽기 전용)', {
            'fields': ('enrollment_count', 'average_rating', 'total_reviews'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['enrollment_count', 'average_rating', 'total_reviews']
    
    def thumbnail_display(self, obj):
        """썸네일 이미지 표시"""
        if obj.thumbnail:
            return format_html(
                '<img src="{}" width="50" height="50" style="object-fit: cover; border-radius: 4px;" />',
                obj.thumbnail.url
            )
        return format_html(
            '<div style="width: 50px; height: 50px; background: #e0e0e0; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 12px; color: #666;">이미지 없음</div>'
        )
    thumbnail_display.short_description = '썸네일'
    
    def price_display(self, obj):
        """가격 정보 표시"""
        if obj.price == 0:
            return format_html('<span style="color: green; font-weight: bold;">무료</span>')
        elif obj.discount_price and obj.discount_price < obj.price:
            return format_html(
                '<span style="text-decoration: line-through; color: #999;">{:,}원</span><br><span style="color: red; font-weight: bold;">{:,}원</span>',
                int(obj.price),
                int(obj.discount_price)
            )
        return format_html('<span style="font-weight: bold;">{:,}원</span>', int(obj.price))
    price_display.short_description = '가격'
    
    def status_display(self, obj):
        """발행 상태 표시"""
        if obj.is_published:
            badge_color = 'green'
            text = '발행됨'
            if obj.is_featured:
                text += ' ?'
        else:
            badge_color = 'orange'
            text = '초안'
        
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            badge_color,
            text
        )
    status_display.short_description = '상태'
    
    def get_queryset(self, request):
        """쿼리셋 최적화"""
        return super().get_queryset(request).select_related(
            'category', 'instructor'
        ).prefetch_related('sections')


@admin.register(CourseSection)
class CourseSectionAdmin(admin.ModelAdmin):
    """강의 섹션 관리"""
    
    list_display = ['title', 'course', 'lesson_count', 'sort_order', 'status_display']
    list_filter = ['course', 'is_active', 'created_at']
    search_fields = ['title', 'description', 'course__title']
    ordering = ['course', 'sort_order']
    
    fieldsets = (
        ('기본 정보', {
            'fields': ('title', 'description', 'course', 'sort_order')
        }),
        ('상태', {
            'fields': ('is_active',)
        }),
    )
    
    def lesson_count(self, obj):
        """섹션의 강의 수"""
        count = obj.lessons.count()
        if count > 0:
            return format_html(
                '<a href="{}?section__id__exact={}">{} 개</a>',
                reverse('admin:courses_lesson_changelist'),
                obj.id,
                count
            )
        return '0 개'
    lesson_count.short_description = '강의 수'
    
    def status_display(self, obj):
        """상태 표시"""
        if obj.is_active:
            return format_html('<span style="color: green;">활성</span>')
        return format_html('<span style="color: red;">비활성</span>')
    status_display.short_description = '상태'


@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    """개별 강의 관리"""
    
    list_display = ['title', 'section', 'lesson_type_display', 'duration_display', 'preview_display', 'sort_order']
    list_filter = ['lesson_type', 'is_preview', 'section__course', 'created_at']
    search_fields = ['title', 'content', 'section__title']
    ordering = ['section', 'sort_order']
    
    fieldsets = (
        ('기본 정보', {
            'fields': ('title', 'content', 'section', 'sort_order')
        }),
        ('강의 타입', {
            'fields': ('lesson_type',)
        }),
        ('비디오 정보', {
            'fields': ('video_url', 'video_duration', 'video_file'),
            'classes': ('collapse',)
        }),
        ('설정', {
            'fields': ('is_preview',)
        }),
        ('자료', {
            'fields': ('attachments',),
            'classes': ('collapse',)
        }),
    )
    
    def lesson_type_display(self, obj):
        """강의 타입 표시"""
        type_colors = {
            'video': '#2196F3',
            'document': '#4CAF50',
            'quiz': '#FF9800',
            'assignment': '#9C27B0'
        }
        type_names = {
            'video': '비디오',
            'document': '문서',
            'quiz': '퀴즈',
            'assignment': '과제'
        }
        
        color = type_colors.get(obj.lesson_type, '#666')
        name = type_names.get(obj.lesson_type, obj.lesson_type)
        
        return format_html(
            '<span style="background: {}; color: white; padding: 3px 8px; border-radius: 12px; font-size: 11px;">{}</span>',
            color,
            name
        )
    lesson_type_display.short_description = '타입'
    
    def duration_display(self, obj):
        """재생 시간 표시"""
        if obj.video_duration:
            minutes = int(obj.video_duration // 60)
            seconds = int(obj.video_duration % 60)
            return f"{minutes}분 {seconds}초"
        return "-"
    duration_display.short_description = '재생시간'
    
    def preview_display(self, obj):
        """미리보기 표시"""
        if obj.is_preview:
            return format_html('<span style="color: green;">? 미리보기</span>')
        return format_html('<span style="color: #666;">? 유료</span>')
    preview_display.short_description = '공개여부'


@admin.register(CourseReview)
class CourseReviewAdmin(admin.ModelAdmin):
    """강의 리뷰 관리"""
    
    list_display = ['course', 'masked_user', 'rating_display', 'title', 'created_at']
    list_filter = ['rating', 'course', 'created_at']
    search_fields = ['title', 'content', 'user__username', 'course__title']
    ordering = ['-created_at']
    
    fieldsets = (
        ('리뷰 정보', {
            'fields': ('course', 'user', 'rating', 'title')
        }),
        ('리뷰 내용', {
            'fields': ('content',)
        }),
        ('메타 정보', {
            'fields': ('created_at',),
            'classes': ('collapse',)
        }),
    )
    
    def masked_user(self, obj):
        """사용자명 마스킹"""
        if obj.user:
            if obj.user.last_name and obj.user.first_name:
                full_name = f"{obj.user.last_name}{obj.user.first_name}"
            else:
                full_name = obj.user.username
            
            if len(full_name) <= 2:
                return full_name
            elif len(full_name) == 3:
                return full_name[0] + '*' + full_name[2]
            else:
                return full_name[0] + '*' * (len(full_name) - 2) + full_name[-1]
        return "-"
    masked_user.short_description = '작성자'
    
    def rating_display(self, obj):
        """평점 시각적 표시"""
        stars = '★' * obj.rating + '☆' * (5 - obj.rating)
        return format_html(
            '<span style="color: #FFD700; font-size: 16px;">{}</span> <span style="color: #666;">({}/5)</span>',
            stars,
            obj.rating
        )
    rating_display.short_description = '평점'