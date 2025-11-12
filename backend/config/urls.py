"""
URL configuration for hancom_lms project.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

from apps.common.views import home_view, api_info
from apps.common.frontend_views import frontend_login, frontend_dashboard, frontend_courses, frontend_profile, frontend_my_courses

# Admin site configuration
admin.site.site_header = "Ministry of Defense LMS Administration"
admin.site.site_title = "MND LMS Admin"
admin.site.index_title = "Management Dashboard"

urlpatterns = [
    # Home page
    path('', home_view, name='home'),
    path('api/', api_info, name='api-info'),
    
    # Frontend pages
    path('frontend/login.html', frontend_login, name='frontend-login'),
    path('frontend/dashboard.html', frontend_dashboard, name='frontend-dashboard'),
    path('frontend/courses.html', frontend_courses, name='frontend-courses'),
    path('frontend/my-courses.html', frontend_my_courses, name='frontend-my-courses'),
    path('frontend/profile.html', frontend_profile, name='frontend-profile'),
    
    # Admin
    path('admin/', admin.site.urls),
    
    # API Documentation
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('api/redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    
    # API endpoints
    path('api/auth/', include('apps.authentication.urls')),
    path('api/courses/', include('apps.courses.urls')),
    path('api/enrollments/', include('apps.enrollments.urls')),
    path('api/notices/', include('apps.notices.urls')),
    path('api/qna/', include('apps.qna.urls')),
    

]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    
    # Debug toolbar
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
    ] + urlpatterns