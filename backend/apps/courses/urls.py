# -*- coding: utf-8 -*-
"""
Courses app URL configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'categories', views.CourseCategoryViewSet)
router.register(r'courses', views.CourseViewSet)
router.register(r'sections', views.CourseSectionViewSet)
router.register(r'lessons', views.LessonViewSet)
router.register(r'reviews', views.CourseReviewViewSet)

urlpatterns = [
    # Course search and filtering
    path('search/', views.CourseSearchView.as_view(), name='course-search'),
    path('featured/', views.FeaturedCoursesView.as_view(), name='featured-courses'),
    
    # Course detail with lessons
    path('courses/<int:course_id>/lessons/', views.CourseLessonsView.as_view(), name='course-lessons'),
    path('courses/<int:course_id>/sections/', views.CourseSectionsView.as_view(), name='course-sections'),
    
    # Reviews
    path('courses/<int:course_id>/reviews/', views.CourseReviewsView.as_view(), name='course-reviews'),
    
    # Router URLs
    path('', include(router.urls)),
]