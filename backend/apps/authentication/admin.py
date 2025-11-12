from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ["username", "email", "user_type", "is_active", "created_at"]
    list_filter = ["user_type", "is_active"]
    search_fields = ["username", "email"]
