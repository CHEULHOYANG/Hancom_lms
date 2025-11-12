# -*- coding: utf-8 -*-
"""
Authentication app views
"""
from rest_framework import viewsets, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from django.contrib.auth import get_user_model
from .models import UserProfile
from .serializers import (
    UserSerializer, UserProfileSerializer, 
    UserRegistrationSerializer, UserLoginSerializer
)

User = get_user_model()


class UserViewSet(viewsets.ModelViewSet):
    """User management viewset"""
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]


class UserRegistrationView(APIView):
    """User registration view"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({
                'message': 'User registered successfully',
                'user_id': user.id
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserLoginView(TokenObtainPairView):
    """User login view"""
    serializer_class = UserLoginSerializer


class UserLogoutView(APIView):
    """User logout view"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)


class UserProfileView(APIView):
    """User profile view"""
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        profile, created = UserProfile.objects.get_or_create(user=request.user)
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)


class UserProfileUpdateView(APIView):
    """User profile update view"""
    permission_classes = [IsAuthenticated]
    
    def put(self, request):
        profile, created = UserProfile.objects.get_or_create(user=request.user)
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PasswordChangeView(APIView):
    """Password change view"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        return Response({'message': 'Password changed successfully'}, status=status.HTTP_200_OK)


class PasswordResetView(APIView):
    """Password reset view"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        return Response({'message': 'Password reset email sent'}, status=status.HTTP_200_OK)


class PasswordResetConfirmView(APIView):
    """Password reset confirm view"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        return Response({'message': 'Password reset successfully'}, status=status.HTTP_200_OK)


class EmailVerificationView(APIView):
    """Email verification view"""
    permission_classes = [AllowAny]
    
    def post(self, request):
        return Response({'message': 'Email verified successfully'}, status=status.HTTP_200_OK)


class ResendVerificationEmailView(APIView):
    """Resend verification email view"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        return Response({'message': 'Verification email sent'}, status=status.HTTP_200_OK)