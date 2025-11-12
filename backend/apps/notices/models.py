# -*- coding: utf-8 -*-
"""
Notice management models
"""
from django.db import models
from django.contrib.auth import get_user_model
from apps.common.models import BaseModel

User = get_user_model()


class Notice(BaseModel):
    """Notice/Announcement model"""
    
    title = models.CharField(max_length=200, verbose_name="Title")
    content = models.TextField(verbose_name="Content")
    author = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name='notices',
        verbose_name="Author"
    )
    
    # Notice Type
    notice_type = models.CharField(
        max_length=20,
        choices=[
            ('general', 'General'),
            ('maintenance', 'Maintenance'),
            ('update', 'Update'),
            ('event', 'Event'),
            ('urgent', 'Urgent'),
        ],
        default='general',
        verbose_name="Notice Type"
    )
    
    # Visibility
    is_published = models.BooleanField(default=True, verbose_name="Is Published")
    is_pinned = models.BooleanField(default=False, verbose_name="Is Pinned")
    
    # Display Settings
    show_on_main = models.BooleanField(default=False, verbose_name="Show on Main Page")
    published_at = models.DateTimeField(null=True, blank=True, verbose_name="Published At")
    
    # Attachments
    attachment = models.FileField(upload_to='notice_attachments/', blank=True, null=True, verbose_name="Attachment")
    
    # Stats
    view_count = models.PositiveIntegerField(default=0, verbose_name="View Count")
    
    class Meta:
        verbose_name = "Notice"
        verbose_name_plural = "Notices"
        ordering = ['-is_pinned', '-published_at', '-created_at']
    
    def __str__(self):
        return self.title


class NoticeReadStatus(BaseModel):
    """Track which users have read which notices"""
    
    notice = models.ForeignKey(
        Notice,
        on_delete=models.CASCADE,
        related_name='read_statuses',
        verbose_name="Notice"
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='notice_read_statuses',
        verbose_name="User"
    )
    read_at = models.DateTimeField(auto_now_add=True, verbose_name="Read At")
    
    class Meta:
        verbose_name = "Notice Read Status"
        verbose_name_plural = "Notice Read Statuses"
        unique_together = ['notice', 'user']
        ordering = ['-read_at']
    
    def __str__(self):
        return f"{self.user.username} - {self.notice.title}"