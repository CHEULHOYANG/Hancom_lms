# -*- coding: utf-8 -*-
"""
Main landing page views
"""
from django.shortcuts import render
from django.http import JsonResponse
from rest_framework.decorators import api_view


def home_view(request):
    """Home page view"""
    context = {
        'title': 'Hancom Campus LMS',
        'api_docs_url': '/api/docs/',
        'admin_url': '/admin/',
        'version': '1.0.0'
    }
    return render(request, 'home.html', context)


@api_view(['GET'])
def api_info(request):
    """API information endpoint"""
    return JsonResponse({
        'name': 'Hancom Campus LMS API',
        'version': '1.0.0',
        'endpoints': {
            'documentation': '/api/docs/',
            'schema': '/api/schema/',
            'auth': '/api/auth/',
            'courses': '/api/courses/',
            'enrollments': '/api/enrollments/',
            'payments': '/api/payments/',
            'notices': '/api/notices/',
            'qna': '/api/qna/',
        }
    })