# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('API', '0003_challenge_last_activity'),
    ]

    operations = [
        migrations.AlterField(
            model_name='challenge',
            name='last_activity',
            field=models.DateField(default=django.utils.timezone.now),
        ),
    ]
