# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime


class Migration(migrations.Migration):

    dependencies = [
        ('API', '0002_remove_challenge_last_activity'),
    ]

    operations = [
        migrations.AddField(
            model_name='challenge',
            name='last_activity',
            field=models.DateField(default=datetime.datetime(2015, 7, 16, 22, 46, 47, 250639)),
        ),
    ]
