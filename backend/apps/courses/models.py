from django.db import models

class CourseCategory(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name

class Course(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    instructor = models.CharField(max_length=100)
    category = models.ForeignKey(CourseCategory, on_delete=models.CASCADE, null=True, blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    is_free = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.title

class CourseSection(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    order = models.IntegerField(default=0)
    
    def __str__(self):
        return f"{self.course.title} - {self.title}"

class Lesson(models.Model):
    section = models.ForeignKey(CourseSection, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    content = models.TextField(blank=True)
    video_url = models.URLField(blank=True)
    order = models.IntegerField(default=0)
    
    def __str__(self):
        return self.title

class CourseReview(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    user = models.CharField(max_length=100)
    rating = models.IntegerField(default=5)
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.course.title} - {self.user}"
