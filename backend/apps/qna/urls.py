# -*- coding: utf-8 -*-
"""
Q&A app URL configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'categories', views.QnaCategoryViewSet)
router.register(r'questions', views.QuestionViewSet)
router.register(r'answers', views.AnswerViewSet)

urlpatterns = [
    # Question management
    path('ask/', views.AskQuestionView.as_view(), name='ask-question'),
    path('questions/<int:question_id>/', views.QuestionDetailView.as_view(), name='question-detail'),
    path('questions/<int:question_id>/answer/', views.AnswerQuestionView.as_view(), name='answer-question'),
    
    # My Q&A
    path('my-questions/', views.MyQuestionsView.as_view(), name='my-questions'),
    path('my-answers/', views.MyAnswersView.as_view(), name='my-answers'),
    
    # FAQ
    path('faq/', views.FAQListView.as_view(), name='faq-list'),
    
    # Search
    path('search/', views.QASearchView.as_view(), name='qa-search'),
    
    # Statistics
    path('questions/<int:question_id>/view/', views.IncrementQuestionViewView.as_view(), name='question-view'),
    
    # Router URLs
    path('api/', include(router.urls)),
]