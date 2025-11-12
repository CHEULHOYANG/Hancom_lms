from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.html import format_html
from .models import User, UserProfile


def mask_name(name):
    if not name or len(name) < 2:
        return name
    if len(name) == 2:
        return name[0] + '*'
    else:
        return name[0] + '*' * (len(name) - 2) + name[-1]


def mask_phone(phone):
    if not phone:
        return "-"
    clean_phone = phone.replace('-', '').replace(' ', '')
    if len(clean_phone) >= 11:
        return f"{clean_phone[:3]}-****-{clean_phone[-4:]}"
    elif len(clean_phone) >= 8:
        return f"{clean_phone[:3]}-****-{clean_phone[-2:]}"
    else:
        return phone


def mask_email(email):
    if not email or '@' not in email:
        return email
    local, domain = email.split('@', 1)
    if len(local) <= 1:
        return email
    elif len(local) <= 3:
        masked_local = local[0] + '*' * (len(local) - 1)
    else:
        masked_local = local[0] + '*' * (len(local) - 2) + local[-1]
    return f"{masked_local}@{domain}"


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('username', 'masked_email', 'masked_first_name', 'masked_last_name', 'is_staff', 'is_active', 'date_joined')
    list_filter = ('is_staff', 'is_active', 'date_joined', 'groups')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('-date_joined',)
    
    # Django admin 한글화
    verbose_name = "사용자"
    verbose_name_plural = "사용자 관리"
    
    def masked_email(self, obj):
        return mask_email(obj.email)
    masked_email.short_description = '이메일'
    
    def masked_first_name(self, obj):
        return mask_name(obj.first_name)
    masked_first_name.short_description = '이름'
    
    def masked_last_name(self, obj):
        return mask_name(obj.last_name)
    masked_last_name.short_description = '성'


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'masked_phone', 'birth_date', 'created_at')
    list_filter = ('created_at', 'birth_date')
    search_fields = ('user__username', 'user__email', 'phone')
    readonly_fields = ('created_at', 'updated_at')
    
    # Django admin 한글화
    verbose_name = "사용자 프로필"
    verbose_name_plural = "사용자 프로필 관리"
    
    def masked_phone(self, obj):
        return mask_phone(obj.phone)
    masked_phone.short_description = '전화번호'
