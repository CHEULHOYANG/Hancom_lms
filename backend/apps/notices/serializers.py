# -*- coding: utf-8 -*-
"""
Notices app serializers
"""
from rest_framework import serializers
from .models import Notice, NoticeReadStatus


class NoticeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notice
        fields = '__all__'


class NoticeReadStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = NoticeReadStatus
        fields = '__all__'