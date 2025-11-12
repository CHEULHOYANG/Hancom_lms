# -*- coding: utf-8 -*-
"""
Q&A app views
"""
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import QnaCategory, Question, Answer


class QnaCategoryViewSet(viewsets.ModelViewSet):
    queryset = QnaCategory.objects.all()


class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()


class AnswerViewSet(viewsets.ModelViewSet):
    queryset = Answer.objects.all()


class AskQuestionView(APIView):
    def post(self, request):
        return Response({'question_id': 1})


class QuestionDetailView(APIView):
    def get(self, request, question_id):
        return Response({'question': {}})


class AnswerQuestionView(APIView):
    def post(self, request, question_id):
        return Response({'answer_id': 1})


class MyQuestionsView(APIView):
    def get(self, request):
        return Response({'questions': []})


class MyAnswersView(APIView):
    def get(self, request):
        return Response({'answers': []})


class FAQListView(APIView):
    def get(self, request):
        return Response({'faq': []})


class QASearchView(APIView):
    def get(self, request):
        return Response({'results': []})


class IncrementQuestionViewView(APIView):
    def post(self, request, question_id):
        return Response({'viewed': True})