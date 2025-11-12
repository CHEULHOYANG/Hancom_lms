# -*- coding: utf-8 -*-
"""
Enrollments app views
"""
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Enrollment, LessonProgress, StudySession


class EnrollmentViewSet(viewsets.ModelViewSet):
    queryset = Enrollment.objects.all()


class LessonProgressViewSet(viewsets.ModelViewSet):
    queryset = LessonProgress.objects.all()


class StudySessionViewSet(viewsets.ModelViewSet):
    queryset = StudySession.objects.all()


class EnrollInCourseView(APIView):
    def post(self, request):
        return Response({'success': True})


class MyCoursesView(APIView):
    def get(self, request):
        return Response({'courses': []})


class CourseProgressView(APIView):
    def get(self, request, course_id):
        return Response({'progress': 0})


class LessonProgressView(APIView):
    def get(self, request, lesson_id):
        return Response({'progress': 0})


class StartStudySessionView(APIView):
    def post(self, request, lesson_id):
        return Response({'session_id': 1})


class EndStudySessionView(APIView):
    def post(self, request, session_id):
        return Response({'success': True})


class CertificateListView(APIView):
    def get(self, request):
        return Response({'certificates': []})


class CourseCertificateView(APIView):
    def get(self, request, course_id):
        return Response({'certificate': None})