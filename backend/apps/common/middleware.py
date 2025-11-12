# -*- coding: utf-8 -*-
"""
Common middleware classes
"""
import logging
from django.http import HttpResponse
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger('security')


class SecurityHeadersMiddleware(MiddlewareMixin):
    """Add security headers to all responses"""
    
    def process_response(self, request, response):
        """Add security headers"""
        response['X-Content-Type-Options'] = 'nosniff'
        response['X-Frame-Options'] = 'DENY'
        response['X-XSS-Protection'] = '1; mode=block'
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        
        return response


class RequestLoggingMiddleware(MiddlewareMixin):
    """Log security-related requests"""
    
    def process_request(self, request):
        """Log potentially suspicious requests"""
        suspicious_patterns = [
            'admin', 'wp-admin', 'phpmyadmin', '.php', '.asp',
            'config', 'backup', 'sql', 'database'
        ]
        
        path = request.path.lower()
        if any(pattern in path for pattern in suspicious_patterns):
            logger.warning(
                f"Suspicious request: {request.method} {request.path} "
                f"from {request.META.get('REMOTE_ADDR', 'unknown')}"
            )
        
        return None