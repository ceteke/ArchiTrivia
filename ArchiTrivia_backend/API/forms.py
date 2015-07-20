from API.models import Question
from django import forms

class QuestionForm(forms.ModelForm):
	class Meta:
		model = Question
		fields = ('name', 'correct_answer', 'ans_1', 'ans_2', 'ans_3')



