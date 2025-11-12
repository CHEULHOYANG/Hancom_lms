# -*- coding: utf-8 -*-
"""
Authentication app configuration
"""
from django.apps import AppConfig


class AuthenticationConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.authentication'
    verbose_name = 'User Authentication'
    
    def ready(self):
        """Code executed when app is initialized"""
        try:
            import apps.authentication.signals
        except ImportError:
            pass
