# -*- coding: utf-8 -*-
"""
QnA app configuration
"""
from django.apps import AppConfig


class QnaConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.qna'
    verbose_name = 'Q&A Management'