# -*- coding: utf-8 -*-
"""
Q&A management models
"""
from django.db import models
from django.contrib.auth import get_user_model
from apps.common.models import BaseModel
from apps.courses.models import Course

User = get_user_model()


class Question(BaseModel):
    """Q&A Question model"""
    
    title = models.CharField(max_length=200, verbose_name="Question Title")
    content = models.TextField(verbose_name="Question Content")
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='questions',
        verbose_name="User"
    )
    course = models.ForeignKey(
        Course,
        on_delete=models.CASCADE,
        related_name='questions',
        null=True,
        blank=True,
        verbose_name="Related Course"
    )
    
    # Question Status
    status = models.CharField(
        max_length=20,
        choices=[
            ('pending', 'Pending'),
            ('answered', 'Answered'),
            ('closed', 'Closed'),
        ],
        default='pending',
        verbose_name="Status"
    )
    
    # Question Category
    category = models.CharField(
        max_length=30,
        choices=[
            ('general', 'General'),
            ('technical', 'Technical'),
            ('payment', 'Payment'),
            ('course_content', 'Course Content'),
            ('certificate', 'Certificate'),
            ('account', 'Account'),
        ],
        default='general',
        verbose_name="Category"
    )
    
    # Priority
    priority = models.CharField(
        max_length=10,
        choices=[
            ('low', 'Low'),
            ('normal', 'Normal'),
            ('high', 'High'),
            ('urgent', 'Urgent'),
        ],
        default='normal',
        verbose_name="Priority"
    )
    
    # Visibility
    is_public = models.BooleanField(default=True, verbose_name="Is Public")
    is_faq = models.BooleanField(default=False, verbose_name="Is FAQ")
    
    # Stats
    view_count = models.PositiveIntegerField(default=0, verbose_name="View Count")
    
    # Attachments
    attachment = models.FileField(upload_to='question_attachments/', blank=True, null=True, verbose_name="Attachment")
    
    class Meta:
        verbose_name = "Question"
        verbose_name_plural = "Questions"
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title


class Answer(BaseModel):
    """Q&A Answer model"""
    
    question = models.ForeignKey(
        Question,
        on_delete=models.CASCADE,
        related_name='answers',
        verbose_name="Question"
    )
    content = models.TextField(verbose_name="Answer Content")
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='answers',
        verbose_name="User"
    )
    
    # Answer Status
    is_staff_answer = models.BooleanField(default=False, verbose_name="Is Staff Answer")
    is_accepted = models.BooleanField(default=False, verbose_name="Is Accepted Answer")
    
    # Attachments
    attachment = models.FileField(upload_to='answer_attachments/', blank=True, null=True, verbose_name="Attachment")
    
    class Meta:
        verbose_name = "Answer"
        verbose_name_plural = "Answers"
        ordering = ['-is_accepted', '-is_staff_answer', 'created_at']
    
    def __str__(self):
        return f"Answer to: {self.question.title}"


class QnaCategory(BaseModel):
    """Q&A Category model for better organization"""
    
    name = models.CharField(max_length=100, verbose_name="Category Name")
    description = models.TextField(blank=True, verbose_name="Description")
    parent = models.ForeignKey(
        'self',
        null=True,
        blank=True,
        on_delete=models.CASCADE,
        related_name='children',
        verbose_name="Parent Category"
    )
    sort_order = models.PositiveIntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "Q&A Category"
        verbose_name_plural = "Q&A Categories"
        ordering = ['sort_order', 'name']
    
    def __str__(self):
        return self.name