from django.db import models
from django.contrib.auth.models import User


class AlertRules(models.Model):

    user = models.ForeignKey(User, unique=True)
    osd_warning = models.CharField(max_length=100, default='1')
    osd_error = models.CharField(max_length=100, default='1')
    mon_warning = models.CharField(max_length=100, default='1')
    mon_error = models.CharField(max_length=100, default='1')
    pg_warning = models.CharField(max_length=100, default='20')
    pg_error = models.CharField(max_length=100, default='20')
    usage_warning = models.CharField(max_length=100, default='70')
    usage_error = models.CharField(max_length=100, default='80')
    general_polling = models.CharField(max_length=100, default='30')
    abnormal_state_polling = models.CharField(max_length=100, default='120')
    abnormal_server_state_polling = models.CharField(max_length=100, default='3600')
    enable_email_notify = models.CharField(max_length=1, default='1')