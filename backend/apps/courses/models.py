from django.db import models
from django.contrib.auth import get_user_model
from apps.common.models import BaseModel

User = get_user_model()

class CourseCategory(BaseModel):
    name = models.CharField(max_length=100, verbose_name="Category Name")
    description = models.TextField(blank=True, verbose_name="Description")
    parent = models.ForeignKey('self', null=True, blank=True, on_delete=models.CASCADE, verbose_name="Parent Category")
    sort_order = models.IntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "Course Category"
        verbose_name_plural = "Course Categories"
        ordering = ['sort_order', 'name']
    
    def __str__(self):
        return self.name

class Course(BaseModel):
    title = models.CharField(max_length=200, verbose_name="Course Title")
    description = models.TextField(verbose_name="Course Description")
    category = models.ForeignKey(CourseCategory, on_delete=models.CASCADE, verbose_name="Category")
    instructor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='taught_courses', verbose_name="Instructor")
    thumbnail = models.ImageField(upload_to='course_thumbnails/', blank=True, verbose_name="Thumbnail")
    duration_hours = models.PositiveIntegerField(default=0, verbose_name="Duration Hours")
    difficulty_level = models.CharField(
        max_length=20,
        choices=[
            ('beginner', 'Beginner'),
            ('intermediate', 'Intermediate'),
            ('advanced', 'Advanced')
        ],
        default='beginner',
        verbose_name="Difficulty Level"
    )
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0, verbose_name="Price")
    is_published = models.BooleanField(default=False, verbose_name="Is Published")
    max_students = models.PositiveIntegerField(null=True, blank=True, verbose_name="Max Students")
    
    class Meta:
        verbose_name = "Course"
        verbose_name_plural = "Courses"
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title

class CourseSection(BaseModel):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='sections', verbose_name="Course")
    title = models.CharField(max_length=200, verbose_name="Section Title")
    description = models.TextField(blank=True, verbose_name="Description")
    sort_order = models.IntegerField(default=0, verbose_name="Sort Order")
    
    class Meta:
        verbose_name = "Course Section"
        verbose_name_plural = "Course Sections"
        ordering = ['sort_order']
    
    def __str__(self):
        return f"{self.course.title} - {self.title}"

class Lesson(BaseModel):
    section = models.ForeignKey(CourseSection, on_delete=models.CASCADE, related_name='lessons', verbose_name="Section")
    title = models.CharField(max_length=200, verbose_name="Lesson Title")
    description = models.TextField(blank=True, verbose_name="Description")
    lesson_type = models.CharField(
        max_length=20,
        choices=[
            ('video', 'Video'),
            ('text', 'Text'),
            ('quiz', 'Quiz'),
            ('assignment', 'Assignment')
        ],
        default='video',
        verbose_name="Lesson Type"
    )
    content_url = models.URLField(blank=True, verbose_name="Content URL")
    video_file = models.FileField(upload_to='lesson_videos/', blank=True, verbose_name="Video File")
    duration_minutes = models.PositiveIntegerField(default=0, verbose_name="Duration Minutes")
    sort_order = models.IntegerField(default=0, verbose_name="Sort Order")
    is_free = models.BooleanField(default=False, verbose_name="Is Free")
    
    class Meta:
        verbose_name = "Lesson"
        verbose_name_plural = "Lessons"
        ordering = ['sort_order']
    
    def __str__(self):
        return f"{self.section.course.title} - {self.title}"

class CourseReview(BaseModel):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='reviews', verbose_name="Course")
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name="User")
    rating = models.IntegerField(choices=[(i, i) for i in range(1, 6)], verbose_name="Rating")
    title = models.CharField(max_length=200, verbose_name="Title")
    content = models.TextField(verbose_name="Content")
    
    class Meta:
        verbose_name = "Course Review"
        verbose_name_plural = "Course Reviews"
        unique_together = ('course', 'user')
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.course.title} - {self.user.username} ({self.rating}¡Ú)"
