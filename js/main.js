// Global state management
let currentUser = null;
let isLoggedIn = false;

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is already logged in (from localStorage)
    const savedUser = localStorage.getItem('hancomLmsUser');
    if (savedUser) {
        currentUser = JSON.parse(savedUser);
        isLoggedIn = true;
        loadUserInterface();
    } else {
        showSection('login');
    }
});

// Login function
function login(event) {
    event.preventDefault();
    
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const userType = document.getElementById('user-type').value;
    
    // Simple validation (in production, this would be server-side)
    if (!username || !password || !userType) {
        alert('모든 필드를 입력해주세요.');
        return false;
    }
    
    // Demo authentication - accept any non-empty credentials
    currentUser = {
        username: username,
        userType: userType,
        loginTime: new Date().toISOString()
    };
    
    // Save to localStorage
    localStorage.setItem('hancomLmsUser', JSON.stringify(currentUser));
    isLoggedIn = true;
    
    // Load the main interface
    loadUserInterface();
    showSection('dashboard');
    
    return false;
}

// Logout function
function logout() {
    if (confirm('로그아웃 하시겠습니까?')) {
        currentUser = null;
        isLoggedIn = false;
        localStorage.removeItem('hancomLmsUser');
        
        // Clear the form
        document.getElementById('login-form').reset();
        
        // Show login section
        showSection('login');
    }
}

// Load user interface with user-specific data
function loadUserInterface() {
    if (!currentUser) return;
    
    // Update profile section
    document.getElementById('profile-name').textContent = currentUser.username;
    document.getElementById('profile-id').textContent = 'ID: ' + currentUser.username;
    
    let userTypeText = '';
    switch(currentUser.userType) {
        case 'student':
            userTypeText = '학생 (병사)';
            break;
        case 'instructor':
            userTypeText = '교관';
            break;
        case 'admin':
            userTypeText = '관리자';
            break;
    }
    document.getElementById('profile-type').textContent = userTypeText;
}

// Show specific section
function showSection(sectionName) {
    // Hide all sections
    const sections = document.querySelectorAll('.section');
    sections.forEach(section => {
        section.classList.remove('active');
    });
    
    // Show the requested section
    const targetSection = document.getElementById(sectionName + '-section');
    if (targetSection) {
        targetSection.classList.add('active');
    }
    
    // Special handling for login section
    if (sectionName === 'login') {
        document.querySelector('.header').style.display = 'none';
        document.querySelector('.footer').style.marginTop = '0';
    } else {
        document.querySelector('.header').style.display = 'block';
        document.querySelector('.footer').style.marginTop = '40px';
    }
}

// Add new course
function addNewCourse() {
    const courseName = prompt('신규 과정명을 입력하세요:');
    if (courseName) {
        alert('과정 "' + courseName + '"이(가) 추가되었습니다.\n(데모 모드: 실제 저장되지 않습니다)');
    }
}

// Add new student
function addNewStudent() {
    const studentName = prompt('학생 이름을 입력하세요:');
    if (studentName) {
        const studentId = prompt('군번을 입력하세요:');
        if (studentId) {
            alert('학생 "' + studentName + '" (군번: ' + studentId + ')이(가) 등록되었습니다.\n(데모 모드: 실제 저장되지 않습니다)');
        }
    }
}

// Add new instructor
function addNewInstructor() {
    const instructorName = prompt('교관 이름을 입력하세요:');
    if (instructorName) {
        const instructorId = prompt('교관 ID를 입력하세요:');
        if (instructorId) {
            alert('교관 "' + instructorName + '" (ID: ' + instructorId + ')이(가) 등록되었습니다.\n(데모 모드: 실제 저장되지 않습니다)');
        }
    }
}

// Search students
function searchStudents(query) {
    const tableBody = document.getElementById('students-table-body');
    const rows = tableBody.getElementsByTagName('tr');
    
    query = query.toLowerCase();
    
    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const text = row.textContent.toLowerCase();
        
        if (text.indexOf(query) > -1) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    }
}

// Sample data management functions
const courseData = {
    'MND-001': {
        name: '군사훈련 기본과정',
        description: '기본 군사훈련 및 체력단련 과정',
        duration: '4주',
        students: 85,
        modules: [
            '기초 체력 훈련',
            '군사 기본 지식',
            '무기 취급 기초',
            '전투 기초 훈련'
        ]
    },
    'MND-002': {
        name: '통신보안 교육',
        description: '군사통신 보안 및 암호화 기술',
        duration: '2주',
        students: 45,
        modules: [
            '암호화 기초',
            '보안 통신 프로토콜',
            '사이버 보안 개론',
            '실전 보안 훈련'
        ]
    },
    'MND-003': {
        name: '전술훈련 교육',
        description: '전술적 사고 및 작전 수행 능력 배양',
        duration: '6주',
        students: 60,
        modules: [
            '전술 기초 이론',
            '지형 분석',
            '작전 계획 수립',
            '전술 실습'
        ]
    },
    'MND-004': {
        name: '응급처치 및 구급',
        description: '전장 응급처치 및 부상자 구급 훈련',
        duration: '3주',
        students: 35,
        modules: [
            '기본 응급처치',
            '전장 의료 지원',
            '부상자 후송',
            '생존 기술'
        ]
    },
    'MND-005': {
        name: '사이버전 대응',
        description: '사이버 공격 및 방어 전략 교육',
        duration: '8주',
        students: 20,
        modules: [
            '사이버 위협 분석',
            '네트워크 보안',
            '침입 탐지 시스템',
            '사이버 방어 전략'
        ]
    }
};

// Get course details
function getCourseDetails(courseCode) {
    return courseData[courseCode] || null;
}

// Generate random statistics for dashboard
function updateDashboardStats() {
    // This would normally fetch real data from a server
    const stats = {
        activeCourses: Object.keys(courseData).length,
        totalStudents: Object.values(courseData).reduce((sum, course) => sum + course.students, 0),
        completionRate: Math.floor(Math.random() * 20) + 70,
        instructors: 12
    };
    
    return stats;
}

// Export functions for use in HTML
window.login = login;
window.logout = logout;
window.showSection = showSection;
window.addNewCourse = addNewCourse;
window.addNewStudent = addNewStudent;
window.addNewInstructor = addNewInstructor;
window.searchStudents = searchStudents;
window.getCourseDetails = getCourseDetails;
