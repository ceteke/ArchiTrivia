from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from API.models import Player, Challenge, Question
from django.core.exceptions import ObjectDoesNotExist
from django.core import serializers
import json
from django.utils import timezone
from API.forms import QuestionForm
# Create your views here.

def index(request):
	return HttpResponse("Welcome to back-end of ArchiTrivia. Nothing protected. Feel free to use.")

def createUser(request):
	id_ = request.GET.get('id')
	uName = request.GET.get('name')
	try:
		player = Player.objects.get(fb_id=id_)
	except ObjectDoesNotExist:
		new_player = Player(fb_id=id_, name=uName)
		new_player.save()
		return JsonResponse({'rank': new_player.rank, 'name': new_player.name, 'fb_id': new_player.fb_id, 'status': 'New Player'})

	return JsonResponse({'fb_id': player.fb_id, 'name': player.name, 'rank': player.rank, 'status': 'Existing Player'})

def getAllUsers(request):
	return HttpResponse(Player.objects.all())

def getRank(request):
	id_ = request.GET.get('id')
	try:
		player = Player.objects.get(fb_id=id_)

	except ObjectDoesNotExist:
		return JsonResponse({'error': 'User Does not Exist'})

	return JsonResponse({'rank': player.rank})

def challengePlayer(request):
	challenger_id = request.GET.get('challenger_id')
	challenged_id = request.GET.get('challenged_id')

	try:
		new_challenger = Player.objects.get(fb_id=challenger_id)
		print(str(new_challenger))
	except ObjectDoesNotExist:
		return JsonResponse({'status': 'failed'})

	try:
		new_challenged = Player.objects.get(fb_id=challenged_id)
		print(str(new_challenged))
	except ObjectDoesNotExist:
		return JsonResponse({'status': 'failed'})

	challenge = Challenge(challenger_id=new_challenger.fb_id, challenged_id=new_challenged.fb_id, challenger_point=0, challenged_point=0)
	challenge.save()
	return JsonResponse({'status': 'created', 'id': challenge.pk})

def getChallenges(request):
	player_id = request.GET.get('id')
	
	challenges_sent = Challenge.objects.all().filter(challenger_id=player_id).order_by('-last_activity')
	challenges_received = Challenge.objects.all().filter(challenged_id=player_id).order_by('-last_activity')

	data = challenges_sent | challenges_received
	data_json = {"challenges": []}
	
	for c in data:
		data_json['challenges'].append({"id": c.pk, "challenger_id": c.challenger_id, "challenged_id": c.challenged_id, "challenger_point": c.challenger_point, "challenged_point": c.challenged_point, "last_activity": str(c.last_activity), "turn": c.turn})

	return HttpResponse(json.dumps(data_json, indent=4), content_type='json')

def getAllQuestions(request):
	questions = Question.objects.all()
	data_json = {'count': len(questions),'questions': []}
	html_string = ""
	for q in questions:
		img_url = q.image_url
		if img_url != "None":
			html_string += "<img src=\""+img_url+"\">"
		html_string += "<h2>" + q.name + "</h2>"
		html_string += "<h4>" + q.correct_answer + "</h4>" + "<hr>"
		
		#data_json['questions'].append({'question': q.name, 'correct_answer': q.correct_answer, 'ans_1': q.ans_1, 'ans_2': q.ans_2, 'ans_3': q.ans_3, 'image_url':q.image_url, 'id': q.pk})

	#return HttpResponse(json.dumps(data_json, indent=4), content_type='json')
	return HttpResponse(html_string, charset="utf-8")

def getRandomQuestion(request):
	question = Question.objects.order_by('?').first()
	
	return HttpResponse(json.dumps(question.to_dict(), indent=4), content_type='json')

def completeAnswering(request):
	player_id = request.GET.get("player_id")
	challenge_id = request.GET.get("challenge_id")
	points_gained = int(request.GET.get("points_gained"))

	try:
		challenge = Challenge.objects.get(pk=challenge_id)
	except ObjectDoesNotExist:
		return JsonResponse({'status': 'failed'})

	if challenge.challenger_id == player_id:
		challenge.challenger_point += points_gained
		challenge.last_activity = timezone.now()
		challenge.turn = 1
		challenge.save()
		if challenge.challenger_point >= 10:
			challenger = Player.objects.get(fb_id=player_id)
			challenger.rank += 20
			challenged = Player.objects.get(fb_id=challenge.challenged_id)
			challenged.rank -= 20
			challenged.save()
			challenger.save()
			challenge.delete()
	elif challenge.challenged_id == player_id:
		challenge.challenged_point += points_gained
		challenge.last_activity = timezone.now()
		challenge.turn = 0
		challenge.save()
		if challenge.challenged_point >= 10:
			challenged = Player.objects.get(fb_id=player_id)
			challenged.rank += 20
			challenger = Player.objects.get(fb_id=challenge.challenger_id)
			challenger.rank -= 20
			challenged.save()
			challenger.save()
			challenge.delete()
	else:
		return JsonResponse({'status': 'failed'})

	return JsonResponse({'status': 'done'})

def addQuestion(request):
	created = False
	if request.method == 'POST':
		form = QuestionForm(request.POST)
		if form.is_valid():
			question = form.save()
			created = True
			form = QuestionForm()
		else:
			print form.errors
	else:
		form = QuestionForm()
	return render(request, 'create_question.html', {'form': form, 'created': created})
	





