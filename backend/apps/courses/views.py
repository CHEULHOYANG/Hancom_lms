# -*- coding: utf-8 -*-
"""
Courses app views
"""
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import CourseCategory, Course, CourseSection, Lesson, CourseReview


class CourseCategoryViewSet(viewsets.ModelViewSet):
    """Course category viewset"""
    queryset = CourseCategory.objects.all()


class CourseViewSet(viewsets.ModelViewSet):
    """Course viewset"""
    queryset = Course.objects.all()


class CourseSectionViewSet(viewsets.ModelViewSet):
    """Course section viewset"""
    queryset = CourseSection.objects.all()


class LessonViewSet(viewsets.ModelViewSet):
    """Lesson viewset"""
    queryset = Lesson.objects.all()


class CourseReviewViewSet(viewsets.ModelViewSet):
    """Course review viewset"""
    queryset = CourseReview.objects.all()


class CourseSearchView(APIView):
    """Course search view"""
    def get(self, request):
        return Response({'results': []})


class FeaturedCoursesView(APIView):
    """Featured courses view"""
    def get(self, request):
        return Response({'results': []})


class CourseLessonsView(APIView):
    """Course lessons view"""
    def get(self, request, course_id):
        return Response({'lessons': []})


class CourseSectionsView(APIView):
    """Course sections view"""
    def get(self, request, course_id):
        return Response({'sections': []})


class CourseReviewsView(APIView):
    """Course reviews view"""
    def get(self, request, course_id):
        return Response({'reviews': []})