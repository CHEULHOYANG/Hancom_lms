from django.contrib import admin
from .models import CourseCategory, Course, CourseSection, Lesson, CourseReview

@admin.register(CourseCategory)
class CourseCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'parent', 'sort_order']
    list_filter = ['parent']
    search_fields = ['name']

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'instructor', 'is_published']
    list_filter = ['category', 'is_published']
    search_fields = ['title']

@admin.register(CourseSection)
class CourseSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'course', 'sort_order']
    list_filter = ['course']
    search_fields = ['title']

@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ['title', 'section', 'lesson_type']
    list_filter = ['lesson_type', 'section__course']
    search_fields = ['title']

@admin.register(CourseReview)
class CourseReviewAdmin(admin.ModelAdmin):
    list_display = ['course', 'user', 'rating']
    list_filter = ['rating', 'course']
    search_fields = ['title']