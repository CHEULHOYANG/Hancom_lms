# -*- coding: utf-8 -*-
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone

class CustomUser(AbstractUser):
    """Extended User Model"""
    GRADE_CHOICES = [
        ('A', 'A Grade (Advanced)'),
        ('B', 'B Grade (Intermediate)'),
        ('C', 'C Grade (Beginner)'),
        ('D', 'D Grade (Basic)'),
    ]
    
    real_name = models.CharField(max_length=50, verbose_name="Real Name", blank=True)
    phone = models.CharField(max_length=20, verbose_name="Phone", blank=True)
    grade = models.CharField(max_length=1, choices=GRADE_CHOICES, default='D', verbose_name="Grade")
    login_count = models.IntegerField(default=0, verbose_name="Login Count")
    total_study_time = models.IntegerField(default=0, verbose_name="Total Study Time (min)")
    last_login_ip = models.GenericIPAddressField(null=True, blank=True, verbose_name="Last Login IP")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")
    
    def get_masked_name(self):
        """Name masking"""
        if not self.real_name or len(self.real_name) < 2:
            return self.real_name
        if len(self.real_name) == 2:
            return self.real_name[0] + '*'
        return self.real_name[0] + '*' * (len(self.real_name) - 2) + self.real_name[-1]
    
    def get_masked_phone(self):
        """Phone masking"""
        if not self.phone or len(self.phone) < 8:
            return self.phone
        if '-' in self.phone:
            parts = self.phone.split('-')
            if len(parts) == 3:
                return f"{parts[0]}-****-{parts[2]}"
        return self.phone[:3] + '****' + self.phone[-4:]
    
    def get_masked_email(self):
        """Email masking"""
        if not self.email or '@' not in self.email:
            return self.email
        local, domain = self.email.split('@', 1)
        if len(local) <= 3:
            masked_local = local[0] + '*' * (len(local) - 1)
        else:
            masked_local = local[:3] + '*' * (len(local) - 3)
        return f"{masked_local}@{domain}"
    
    class Meta:
        verbose_name = "User"
        verbose_name_plural = "User Management"

class CourseCategory(models.Model):
    """Course Category"""
    name = models.CharField(max_length=100, verbose_name="Category Name")
    description = models.TextField(blank=True, verbose_name="Description")
    order = models.IntegerField(default=0, verbose_name="Order")
    is_active = models.BooleanField(default=True, verbose_name="Active")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    
    class Meta:
        verbose_name = "Course Category"
        verbose_name_plural = "Course Categories"
        ordering = ['order', 'name']
    
    def __str__(self):
        return self.name

class Course(models.Model):
    """Course"""
    STATUS_CHOICES = [
        ('draft', 'Draft'),
        ('published', 'Published'),
        ('completed', 'Completed'),
        ('suspended', 'Suspended'),
    ]
    
    LEVEL_CHOICES = [
        ('beginner', 'Beginner'),
        ('intermediate', 'Intermediate'),
        ('advanced', 'Advanced'),
        ('expert', 'Expert'),
    ]
    
    title = models.CharField(max_length=200, verbose_name="Course Title")
    category = models.ForeignKey(CourseCategory, on_delete=models.CASCADE, verbose_name="Category")
    description = models.TextField(verbose_name="Description")
    thumbnail = models.ImageField(upload_to='courses/', blank=True, verbose_name="Thumbnail")
    instructor = models.CharField(max_length=100, verbose_name="Instructor")
    duration_weeks = models.IntegerField(verbose_name="Duration (weeks)")
    level = models.CharField(max_length=20, choices=LEVEL_CHOICES, verbose_name="Level")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='draft', verbose_name="Status")
    max_students = models.IntegerField(default=100, verbose_name="Max Students")
    current_students = models.IntegerField(default=0, verbose_name="Current Students")
    price = models.DecimalField(max_digits=10, decimal_places=0, default=0, verbose_name="Price")
    start_date = models.DateField(verbose_name="Start Date")
    end_date = models.DateField(verbose_name="End Date")
    is_featured = models.BooleanField(default=False, verbose_name="Featured")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")
    
    class Meta:
        verbose_name = "Course"
        verbose_name_plural = "Course Management"
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title
    
    def get_enrollment_rate(self):
        """Enrollment rate"""
        if self.max_students == 0:
            return 0
        return round((self.current_students / self.max_students) * 100, 1)

class Enrollment(models.Model):
    """Course Enrollment"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('completed', 'Completed'),
    ]
    
    student = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Student")
    course = models.ForeignKey(Course, on_delete=models.CASCADE, verbose_name="Course")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending', verbose_name="Status")
    enrolled_at = models.DateTimeField(auto_now_add=True, verbose_name="Enrolled Date")
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name="Completed Date")
    progress = models.IntegerField(default=0, verbose_name="Progress(%)")
    
    class Meta:
        verbose_name = "Enrollment"
        verbose_name_plural = "Enrollment Management"
        unique_together = ['student', 'course']
    
    def __str__(self):
        return f"{self.student.username} - {self.course.title}"

class Board(models.Model):
    """Board"""
    BOARD_TYPE_CHOICES = [
        ('notice', 'Notice'),
        ('free', 'Free Board'),
        ('qna', 'Q&A'),
        ('event', 'Event'),
    ]
    
    name = models.CharField(max_length=100, verbose_name="Board Name")
    board_type = models.CharField(max_length=20, choices=BOARD_TYPE_CHOICES, verbose_name="Board Type")
    description = models.TextField(blank=True, verbose_name="Description")
    is_active = models.BooleanField(default=True, verbose_name="Active")
    order = models.IntegerField(default=0, verbose_name="Order")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created Date")
    
    class Meta:
        verbose_name = "Board"
        verbose_name_plural = "Board Management"
        ordering = ['order', 'name']
    
    def __str__(self):
        return self.name

class Post(models.Model):
    """Post"""
    board = models.ForeignKey(Board, on_delete=models.CASCADE, verbose_name="Board")
    title = models.CharField(max_length=200, verbose_name="Title")
    content = models.TextField(verbose_name="Content")
    author = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Author")
    is_notice = models.BooleanField(default=False, verbose_name="Notice")
    is_secret = models.BooleanField(default=False, verbose_name="Secret")
    views = models.IntegerField(default=0, verbose_name="Views")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created Date")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated Date")
    
    class Meta:
        verbose_name = "Post"
        verbose_name_plural = "Post Management"
        ordering = ['-is_notice', '-created_at']
    
    def __str__(self):
        return self.title

class SiteSettings(models.Model):
    """Site Settings"""
    site_name = models.CharField(max_length=100, default="MND Learning Management System", verbose_name="Site Name")
    site_description = models.TextField(blank=True, verbose_name="Site Description")
    admin_email = models.EmailField(default="admin@example.com", verbose_name="Admin Email")
    phone = models.CharField(max_length=20, blank=True, verbose_name="Phone")
    address = models.TextField(blank=True, verbose_name="Address")
    logo = models.ImageField(upload_to='site/', blank=True, verbose_name="Logo")
    favicon = models.ImageField(upload_to='site/', blank=True, verbose_name="Favicon")
    
    # Homepage settings
    hero_title = models.CharField(max_length=200, default="MND Learning Management System", verbose_name="Hero Title")
    hero_subtitle = models.CharField(max_length=500, default="Professional Military Education and Training System", verbose_name="Hero Subtitle")
    hero_image = models.ImageField(upload_to='site/', blank=True, verbose_name="Hero Image")
    
    # Feature settings
    allow_registration = models.BooleanField(default=True, verbose_name="Allow Registration")
    email_verification = models.BooleanField(default=False, verbose_name="Email Verification")
    maintenance_mode = models.BooleanField(default=False, verbose_name="Maintenance Mode")
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created Date")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated Date")
    
    class Meta:
        verbose_name = "Site Settings"
        verbose_name_plural = "Site Settings"
    
    def __str__(self):
        return self.site_name
    
    def save(self, *args, **kwargs):
        # Only allow one instance
        if not self.pk and SiteSettings.objects.exists():
            raise ValueError('Only one SiteSettings instance is allowed.')
        return super().save(*args, **kwargs)
