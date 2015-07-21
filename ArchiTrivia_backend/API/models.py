from django.db import models
from django.utils import timezone
# Create your models here.

class Question(models.Model):
	name = models.CharField(max_length=400)
	correct_answer = models.CharField(max_length=400)
	ans_1 = models.CharField(max_length=400)
	ans_2 = models.CharField(max_length=400)
	ans_3 = models.CharField(max_length=400)
	image_url = models.CharField(max_length=400, default="None")

	def to_dict(self):
		return {"name": self.name, "ans_1": self.ans_1, "ans_2": self.ans_2, "ans_3": self.ans_3, "correct_answer": self.correct_answer, 'image_url': self.image_url}

class Player(models.Model):
	name = models.CharField(max_length=200)
	fb_id = models.CharField(max_length=200)
	rank = models.IntegerField(default=2700)

	def __str__(self):
		return self.name + " " + str(self.rank) + " " + str(self.fb_id) + "<p>" 

class Challenge(models.Model):
	challenger_id = models.CharField(max_length=200, default=0)
	challenged_id = models.CharField(max_length=200, default=0)
	challenger_point = models.IntegerField()
	challenged_point = models.IntegerField()
	last_activity = models.DateTimeField(default=timezone.now)
	turn = models.IntegerField(default=0)


	