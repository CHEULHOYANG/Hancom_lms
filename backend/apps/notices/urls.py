# -*- coding: utf-8 -*-
"""
Notices app URL configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'notices', views.NoticeViewSet)

urlpatterns = [
    # Notice management
    path('', views.NoticeListView.as_view(), name='notice-list'),
    path('<int:notice_id>/', views.NoticeDetailView.as_view(), name='notice-detail'),
    path('<int:notice_id>/read/', views.MarkNoticeAsReadView.as_view(), name='mark-notice-read'),
    
    # Main page notices
    path('main/', views.MainPageNoticesView.as_view(), name='main-notices'),
    path('pinned/', views.PinnedNoticesView.as_view(), name='pinned-notices'),
    
    # Unread notices
    path('unread/', views.UnreadNoticesView.as_view(), name='unread-notices'),
    path('unread/count/', views.UnreadNoticeCountView.as_view(), name='unread-notice-count'),
    
    # Router URLs
    path('api/', include(router.urls)),
]