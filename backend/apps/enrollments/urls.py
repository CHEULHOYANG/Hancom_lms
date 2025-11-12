# -*- coding: utf-8 -*-
"""
Enrollments app URL configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'enrollments', views.EnrollmentViewSet)
router.register(r'progress', views.LessonProgressViewSet)
router.register(r'sessions', views.StudySessionViewSet)

urlpatterns = [
    # Enrollment management
    path('enroll/', views.EnrollInCourseView.as_view(), name='enroll-course'),
    path('my-courses/', views.MyCoursesView.as_view(), name='my-courses'),
    
    # Progress tracking
    path('courses/<int:course_id>/progress/', views.CourseProgressView.as_view(), name='course-progress'),
    path('lessons/<int:lesson_id>/progress/', views.LessonProgressView.as_view(), name='lesson-progress'),
    
    # Study sessions
    path('lessons/<int:lesson_id>/start-session/', views.StartStudySessionView.as_view(), name='start-session'),
    path('sessions/<int:session_id>/end/', views.EndStudySessionView.as_view(), name='end-session'),
    
    # Certificates
    path('certificates/', views.CertificateListView.as_view(), name='certificates'),
    path('courses/<int:course_id>/certificate/', views.CourseCertificateView.as_view(), name='course-certificate'),
    
    # Router URLs
    path('', include(router.urls)),
]