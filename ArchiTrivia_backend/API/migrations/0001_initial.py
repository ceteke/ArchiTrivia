# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Challenge',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('challenger_id', models.CharField(default=0, max_length=200)),
                ('challenged_id', models.CharField(default=0, max_length=200)),
                ('challenger_point', models.IntegerField()),
                ('challenged_point', models.IntegerField()),
                ('last_activity', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='Player',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=200)),
                ('fb_id', models.CharField(max_length=200)),
                ('rank', models.IntegerField(default=2700)),
            ],
        ),
        migrations.CreateModel(
            name='Question',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=400)),
                ('correct_answer', models.CharField(max_length=400)),
                ('ans_1', models.CharField(max_length=400)),
                ('ans_2', models.CharField(max_length=400)),
                ('ans_3', models.CharField(max_length=400)),
            ],
        ),
    ]
