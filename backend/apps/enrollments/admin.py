from django.contrib import admin
from .models import Enrollment, LessonProgress, StudySession

@admin.register(Enrollment)
class EnrollmentAdmin(admin.ModelAdmin):
    list_display = ["user", "course", "enrolled_at", "completed"]
    list_filter = ["enrolled_at", "completed"]

@admin.register(LessonProgress)
class LessonProgressAdmin(admin.ModelAdmin):
    list_display = ["enrollment", "lesson_id", "completed", "progress_percent"]
    list_filter = ["completed"]

@admin.register(StudySession)
class StudySessionAdmin(admin.ModelAdmin):
    list_display = ["enrollment", "started_at", "ended_at", "duration_minutes"]
