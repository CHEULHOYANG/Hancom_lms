// Hancom Defense Ministry LMS JavaScript

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Login form handling
document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    // Simple validation (in real application, this would connect to a backend)
    if (username && password) {
        alert('로그인 기능은 백엔드 서버와 연동하여 구현됩니다.\n사용자: ' + username);
        // In a real application, you would send credentials to server here
        // fetch('/api/login', { method: 'POST', body: JSON.stringify({username, password}) })
    } else {
        alert('사용자 ID와 비밀번호를 입력해주세요.');
    }
});

// Course card interaction
document.querySelectorAll('.course-card .btn-secondary').forEach(button => {
    button.addEventListener('click', function() {
        const courseTitle = this.parentElement.querySelector('h3').textContent;
        alert('교육 과정 상세 정보\n\n과정명: ' + courseTitle + '\n\n상세 정보는 개발 중입니다.');
    });
});

// Add active class to current navigation item
window.addEventListener('scroll', function() {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('nav a');
    
    let current = '';
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (window.pageYOffset >= sectionTop - 60) {
            current = section.getAttribute('id');
        }
    });
    
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === '#' + current) {
            link.classList.add('active');
        }
    });
});

// Welcome message on page load
window.addEventListener('load', function() {
    console.log('한컴 국방부 교육 시스템에 오신 것을 환영합니다.');
    console.log('Hancom Defense Ministry Education System - Version 1.0');
});
