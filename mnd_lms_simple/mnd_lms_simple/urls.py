# -*- coding: utf-8 -*-
from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from . import views

# Django admin interface
admin.site.site_header = "MND Learning Management System Admin"
admin.site.site_title = "MND LMS Admin" 
admin.site.index_title = "Admin Dashboard"

urlpatterns = [
    path('', views.home, name='home'),
    path('login/', views.user_login, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('register/', views.register_view, name='register'),
    path('my-courses/', views.my_courses, name='my_courses'),
    
    # 기본 Django Admin
    path('admin/', admin.site.urls),
    
    # 커스텀 관리자 페이지
    path('admin-dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('admin/users/', views.user_management, name='user_management'),
    path('admin/users/<int:user_id>/', views.user_detail, name='user_detail'),
    path('admin/users/<int:user_id>/reset-password/', views.reset_password, name='reset_password'),
    path('admin/courses/', views.course_management, name='course_management'),
    path('admin/boards/', views.board_management, name='board_management'),
    path('admin/posts/', views.post_management, name='post_management'),
    path('admin/posts/<int:board_id>/', views.post_management, name='post_management_by_board'),
    path('admin/settings/', views.site_settings, name='site_settings'),
    
    # 기타 페이지
    path('health/', views.health_check, name='health_check'),
    path('course-registration/', views.course_registration, name='course_registration'),
    path('community/', views.community, name='community'),
    path('support/', views.support, name='support'),
]

# 미디어 파일 제공 (개발 환경)
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
