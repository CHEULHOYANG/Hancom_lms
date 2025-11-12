from django.contrib import admin
from .models import QnaCategory, Question, Answer

@admin.register(QnaCategory)
class QnaCategoryAdmin(admin.ModelAdmin):
    list_display = ["name", "created_at"]
    search_fields = ["name", "description"]

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ["title", "author", "category", "created_at"]
    list_filter = ["category"]
    search_fields = ["title", "content"]

@admin.register(Answer)
class AnswerAdmin(admin.ModelAdmin):
    list_display = ["question", "author", "created_at"]
