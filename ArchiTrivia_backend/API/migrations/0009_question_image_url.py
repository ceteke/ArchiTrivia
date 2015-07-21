# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('API', '0008_challenge_turn'),
    ]

    operations = [
        migrations.AddField(
            model_name='question',
            name='image_url',
            field=models.CharField(default=b'None', max_length=400),
        ),
    ]
