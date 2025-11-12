from django.db import models
from django.conf import settings

class Notice(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.PROTECT)
    is_pinned = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = "notice"
        ordering = ["-is_pinned", "-created_at"]
    
    def __str__(self):
        return self.title
