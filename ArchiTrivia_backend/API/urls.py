from django.conf.urls import patterns, url, include
from API import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^createUser', views.createUser, name='createUser'),
    url(r'^getAllUsers', views.getAllUsers, name='getAllUsers'),
    url(r'^getRank', views.getRank, name='getRank'),
    url(r'^challenge', views.challengePlayer, name='challengePlayer'),
    url(r'^getChallenges', views.getChallenges, name='getChallenges'),
    url(r'^completeAnswering', views.completeAnswering, name='completeAnswering'),
    url(r'^getRandomQuestion', views.getRandomQuestion, name='getRandomQuestion'),
 	url(r'^addQuestion', views.addQuestion, name='addQuestion'),
 	url(r'^getAllQuestions', views.getAllQuestions, name='getAllQuestions'),

]



