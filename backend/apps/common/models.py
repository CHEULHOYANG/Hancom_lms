# -*- coding: utf-8 -*-
"""
Common models and abstract base classes
"""
from django.db import models
from django.utils import timezone


class BaseModel(models.Model):
    """Abstract base model with common fields"""
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")
    is_active = models.BooleanField(default=True, verbose_name="Is Active")
    
    class Meta:
        abstract = True
        ordering = ['-created_at']
    
    def soft_delete(self):
        """Soft delete by setting is_active to False"""
        self.is_active = False
        self.save(update_fields=['is_active', 'updated_at'])
    
    def restore(self):
        """Restore soft deleted object"""
        self.is_active = True
        self.save(update_fields=['is_active', 'updated_at'])


class TimeStampedModel(models.Model):
    """Abstract model with timestamp fields only"""
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")
    
    class Meta:
        abstract = True
        ordering = ['-created_at']


class ActiveManager(models.Manager):
    """Manager that returns only active objects"""
    
    def get_queryset(self):
        return super().get_queryset().filter(is_active=True)


class AllObjectsManager(models.Manager):
    """Manager that returns all objects including inactive ones"""
    
    def get_queryset(self):
        return super().get_queryset()