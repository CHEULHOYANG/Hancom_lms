# -*- coding: utf-8 -*-
"""
User authentication models
"""
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.core.validators import RegexValidator
from apps.common.models import BaseModel


class User(AbstractUser):
    """Extended user model with additional fields"""
    
    # Personal Information
    korean_name = models.CharField(max_length=50, verbose_name="Korean Name")
    english_name = models.CharField(max_length=100, blank=True, verbose_name="English Name")
    
    # Contact Information  
    phone_regex = RegexValidator(
        regex=r'^\+?1?\d{9,15}$',
        message="Phone number format: '+999999999'. Up to 15 digits allowed."
    )
    phone_number = models.CharField(
        validators=[phone_regex], 
        max_length=17, 
        unique=True,
        verbose_name="Phone Number"
    )
    
    # Status
    is_verified = models.BooleanField(default=False, verbose_name="Email Verified")
    is_instructor = models.BooleanField(default=False, verbose_name="Is Instructor")
    
    # Timestamps
    last_activity = models.DateTimeField(null=True, blank=True, verbose_name="Last Activity")
    
    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        db_table = 'auth_user'
    
    def __str__(self):
        return f"{self.username} ({self.korean_name})"


class UserProfile(BaseModel):
    """User profile with additional information"""
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    
    # Profile Information
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    bio = models.TextField(blank=True, verbose_name="Biography")
    birth_date = models.DateField(null=True, blank=True, verbose_name="Birth Date")
    
    # Address Information
    address = models.CharField(max_length=200, blank=True, verbose_name="Address")
    city = models.CharField(max_length=50, blank=True, verbose_name="City")
    postal_code = models.CharField(max_length=10, blank=True, verbose_name="Postal Code")
    
    # Educational Background
    education_level = models.CharField(
        max_length=20,
        choices=[
            ('high_school', 'High School'),
            ('bachelor', 'Bachelor Degree'),
            ('master', 'Master Degree'),
            ('phd', 'PhD'),
            ('other', 'Other'),
        ],
        blank=True,
        verbose_name="Education Level"
    )
    
    # Work Information
    company = models.CharField(max_length=100, blank=True, verbose_name="Company")
    job_title = models.CharField(max_length=100, blank=True, verbose_name="Job Title")
    
    # Preferences
    language_preference = models.CharField(
        max_length=10,
        choices=[
            ('ko', 'Korean'),
            ('en', 'English'),
        ],
        default='ko',
        verbose_name="Language Preference"
    )
    
    # Marketing
    marketing_agreed = models.BooleanField(default=False, verbose_name="Marketing Agreement")
    
    class Meta:
        verbose_name = "User Profile"
        verbose_name_plural = "User Profiles"
        db_table = 'user_profile'
    
    def __str__(self):
        return f"{self.user.username} Profile"