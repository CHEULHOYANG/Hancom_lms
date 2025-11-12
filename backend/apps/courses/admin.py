from django.contrib import admin
from .models import CourseCategory, Course, CourseSection, Lesson, CourseReview

@admin.register(CourseCategory)
class CourseCategoryAdmin(admin.ModelAdmin):
    list_display = ["name", "created_at"]
    search_fields = ["name", "description"]

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ["title", "instructor", "category", "price", "is_free", "created_at"]
    list_filter = ["is_free", "category"]
    search_fields = ["title", "description"]

@admin.register(CourseSection)
class CourseSectionAdmin(admin.ModelAdmin):
    list_display = ["course", "title", "order"]
    list_filter = ["course"]

@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ["section", "title", "order"]
    search_fields = ["title", "content"]

@admin.register(CourseReview)
class CourseReviewAdmin(admin.ModelAdmin):
    list_display = ["course", "user", "rating", "created_at"]
    list_filter = ["rating"]
