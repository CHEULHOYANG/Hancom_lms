from django.shortcuts import render

def frontend_login(request):
    return render(request, 'frontend/login.html')

def frontend_dashboard(request):
    return render(request, 'frontend/dashboard.html')

def frontend_courses(request):
    return render(request, 'frontend/courses.html')

def frontend_my_courses(request):
    return render(request, 'frontend/my-courses.html')

def frontend_profile(request):
    return render(request, 'frontend/profile.html')