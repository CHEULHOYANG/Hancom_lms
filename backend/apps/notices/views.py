# -*- coding: utf-8 -*-
"""
Notices app views
"""
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Notice


class NoticeViewSet(viewsets.ModelViewSet):
    queryset = Notice.objects.all()


class NoticeListView(APIView):
    def get(self, request):
        return Response({'notices': []})


class NoticeDetailView(APIView):
    def get(self, request, notice_id):
        return Response({'notice': {}})


class MarkNoticeAsReadView(APIView):
    def post(self, request, notice_id):
        return Response({'read': True})


class MainPageNoticesView(APIView):
    def get(self, request):
        return Response({'notices': []})


class PinnedNoticesView(APIView):
    def get(self, request):
        return Response({'notices': []})


class UnreadNoticesView(APIView):
    def get(self, request):
        return Response({'notices': []})


class UnreadNoticeCountView(APIView):
    def get(self, request):
        return Response({'count': 0})