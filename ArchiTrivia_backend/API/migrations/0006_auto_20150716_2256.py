# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('API', '0005_auto_20150716_2255'),
    ]

    operations = [
        migrations.AlterField(
            model_name='challenge',
            name='last_activity',
            field=models.DateTimeField(default=datetime.datetime(2015, 7, 16, 22, 56, 18, 201095, tzinfo=utc)),
        ),
    ]
