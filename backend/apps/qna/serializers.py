# -*- coding: utf-8 -*-
"""
Q&A app serializers
"""
from rest_framework import serializers
from .models import QnaCategory, Question, Answer


class QnaCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = QnaCategory
        fields = '__all__'


class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = '__all__'


class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = '__all__'