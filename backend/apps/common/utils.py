"""
Common utility functions
"""
import re
import hashlib
import secrets
from typing import Optional
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _


def validate_password_strength(password: str) -> None:
    """
    비밀번호 강도 검증
    
    Args:
        password: 검증할 비밀번호
        
    Raises:
        ValidationError: 비밀번호가 조건을 만족하지 않을 때
    """
    if len(password) < 8:
        raise ValidationError(_('비밀번호는 최소 8자 이상이어야 합니다.'))
    
    if not re.search(r'[A-Z]', password):
        raise ValidationError(_('비밀번호는 대문자를 포함해야 합니다.'))
    
    if not re.search(r'[a-z]', password):
        raise ValidationError(_('비밀번호는 소문자를 포함해야 합니다.'))
    
    if not re.search(r'\d', password):
        raise ValidationError(_('비밀번호는 숫자를 포함해야 합니다.'))
    
    if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
        raise ValidationError(_('비밀번호는 특수문자를 포함해야 합니다.'))


def sanitize_input(text: str) -> str:
    """
    사용자 입력 데이터 정제
    
    Args:
        text: 정제할 텍스트
        
    Returns:
        정제된 텍스트
    """
    if not text:
        return ""
    
    # HTML 태그 제거
    text = re.sub(r'<[^>]+>', '', text)
    
    # 스크립트 태그 제거
    text = re.sub(r'<script[^>]*>.*?</script>', '', text, flags=re.IGNORECASE | re.DOTALL)
    
    # 위험한 문자 제거
    dangerous_chars = ['<', '>', '"', "'", '&', '\\', '/', '`']
    for char in dangerous_chars:
        text = text.replace(char, '')
    
    return text.strip()


def generate_secure_token(length: int = 32) -> str:
    """
    보안 토큰 생성
    
    Args:
        length: 토큰 길이
        
    Returns:
        생성된 토큰
    """
    return secrets.token_urlsafe(length)


def generate_file_hash(file_content: bytes) -> str:
    """
    파일 해시 생성
    
    Args:
        file_content: 파일 내용
        
    Returns:
        SHA256 해시 값
    """
    return hashlib.sha256(file_content).hexdigest()


def validate_file_extension(filename: str, allowed_extensions: list) -> bool:
    """
    파일 확장자 검증
    
    Args:
        filename: 파일명
        allowed_extensions: 허용된 확장자 목록
        
    Returns:
        유효한 확장자인지 여부
    """
    if not filename:
        return False
    
    extension = filename.lower().split('.')[-1]
    return extension in [ext.lower() for ext in allowed_extensions]


def validate_file_size(file_size: int, max_size_mb: int = 5) -> bool:
    """
    파일 크기 검증
    
    Args:
        file_size: 파일 크기 (bytes)
        max_size_mb: 최대 크기 (MB)
        
    Returns:
        유효한 크기인지 여부
    """
    max_size_bytes = max_size_mb * 1024 * 1024
    return file_size <= max_size_bytes


def mask_email(email: str) -> str:
    """
    이메일 마스킹
    
    Args:
        email: 원본 이메일
        
    Returns:
        마스킹된 이메일
    """
    if not email or '@' not in email:
        return email
    
    local, domain = email.split('@', 1)
    
    if len(local) <= 2:
        masked_local = local
    else:
        masked_local = local[0] + '*' * (len(local) - 2) + local[-1]
    
    return f"{masked_local}@{domain}"


def mask_phone(phone: str) -> str:
    """
    전화번호 마스킹
    
    Args:
        phone: 원본 전화번호
        
    Returns:
        마스킹된 전화번호
    """
    if not phone:
        return phone
    
    # 숫자만 추출
    digits = re.sub(r'\D', '', phone)
    
    if len(digits) >= 8:
        return digits[:3] + '*' * (len(digits) - 6) + digits[-3:]
    
    return phone


def get_client_ip(request) -> Optional[str]:
    """
    클라이언트 IP 주소 추출
    
    Args:
        request: Django request 객체
        
    Returns:
        클라이언트 IP 주소
    """
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0].strip()
    else:
        ip = request.META.get('REMOTE_ADDR')
    
    return ip


def is_safe_url(url: str, allowed_hosts: list) -> bool:
    """
    안전한 URL인지 검증
    
    Args:
        url: 검증할 URL
        allowed_hosts: 허용된 호스트 목록
        
    Returns:
        안전한 URL인지 여부
    """
    if not url:
        return False
    
    # 스키마 검증
    if not url.startswith(('http://', 'https://', '/')):
        return False
    
    # 상대 URL인 경우 안전하다고 판단
    if url.startswith('/'):
        return True
    
    # 절대 URL인 경우 호스트 검증
    try:
        from urllib.parse import urlparse
        parsed = urlparse(url)
        return parsed.hostname in allowed_hosts
    except Exception:
        return False