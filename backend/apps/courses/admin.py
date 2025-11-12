from django.contrib import admin
from .models import CourseCategory, Course, CourseSection, Lesson, CourseReview

@admin.register(CourseCategory)
class CourseCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'parent', 'sort_order']
    list_filter = ['parent']
    search_fields = ['name']
    
    # Django admin 한글화
    verbose_name = "과정 카테고리"
    verbose_name_plural = "과정 카테고리 관리"

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'instructor', 'is_published']
    list_filter = ['category', 'is_published']
    search_fields = ['title']
    
    # Django admin 한글화
    verbose_name = "과정"
    verbose_name_plural = "과정 관리"

@admin.register(CourseSection)
class CourseSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'course', 'sort_order']
    list_filter = ['course']
    search_fields = ['title']
    
    # Django admin 한글화
    verbose_name = "과정 섹션"
    verbose_name_plural = "과정 섹션 관리"

@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ['title', 'section', 'lesson_type']
    list_filter = ['lesson_type', 'section__course']
    search_fields = ['title']
    
    # Django admin 한글화
    verbose_name = "레슨"
    verbose_name_plural = "레슨 관리"

@admin.register(CourseReview)
class CourseReviewAdmin(admin.ModelAdmin):
    list_display = ['course', 'user', 'rating']
    list_filter = ['rating', 'course']
    search_fields = ['title']
    
    # Django admin 한글화
    verbose_name = "과정 리뷰"
    verbose_name_plural = "과정 리뷰 관리"
