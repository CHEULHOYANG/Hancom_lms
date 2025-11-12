from django.db import models

class Enrollment(models.Model):
    user = models.CharField(max_length=100)
    course = models.CharField(max_length=200)
    enrolled_at = models.DateTimeField(auto_now_add=True)
    completed = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.user} - {self.course}"

class LessonProgress(models.Model):
    enrollment = models.ForeignKey(Enrollment, on_delete=models.CASCADE)
    lesson_id = models.IntegerField()
    completed = models.BooleanField(default=False)
    progress_percent = models.IntegerField(default=0)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"{self.enrollment} - Lesson {self.lesson_id}"

class StudySession(models.Model):
    enrollment = models.ForeignKey(Enrollment, on_delete=models.CASCADE)
    started_at = models.DateTimeField(auto_now_add=True)
    ended_at = models.DateTimeField(null=True, blank=True)
    duration_minutes = models.IntegerField(default=0)
    
    def __str__(self):
        return f"{self.enrollment} - {self.started_at}"
