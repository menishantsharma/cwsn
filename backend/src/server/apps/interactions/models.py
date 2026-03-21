# apps/interactions/models.py
from django.db import models
from apps.users.models import User
from django.conf import settings
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

class ServiceRequest(models.Model):
    STATUS_CHOICES = [('Pending', 'Pending'), ('Accepted', 'Accepted'), ('Rejected', 'Rejected')]

    cwsn_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='sent_requests')
    caregiver = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='received_requests')
    child = models.ForeignKey('users.ChildProfile', on_delete=models.CASCADE, related_name='service_requests')
    service = models.ForeignKey('services.Service', on_delete=models.CASCADE, related_name='requests')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Pending')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('cwsn_user', 'child', 'service')

    def __str__(self):
        return f"Request from {self.cwsn_user.email} for {self.service.title}"

@receiver(post_save, sender=ServiceRequest)
def populate_caregiver(sender, instance, created, **kwargs):
    # Automatically set the caregiver from the service
    if created:
        instance.caregiver = instance.service.caregiver
        instance.save()

class Report(models.Model):
    STATUS_CHOICES = [('Open', 'Open'), ('Resolved', 'Resolved'), ('Dismissed', 'Dismissed')]
    
    reporter = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='filed_reports')
    reported_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reports_against')
    reason = models.TextField()
    region_of_incident = models.ForeignKey('common.Region', on_delete=models.SET_NULL, null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Open')
    created_at = models.DateTimeField(auto_now_add=True)
    moderator_action = models.TextField(blank=True, null=True, help_text="[Moderator only] Action taken or notes.")

    def __str__(self):
        return f"Report against {self.reported_user.email} by {self.reporter.email}"

@receiver(post_save, sender=Report)
def populate_report_region(sender, instance, created, **kwargs):
    # Automatically set region from the reported user's profile if they are a caregiver
    if created and instance.reported_user.is_caregiver:
        try:
            instance.region_of_incident = instance.reported_user.caregiver_profile.region
            instance.save()
        except:
            pass # Handle case where profile might not exist yet

class Upvote(models.Model):
    voter = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='given_upvotes')
    caregiver = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='received_upvotes')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['voter', 'caregiver'], name='unique_upvote')
        ]

@receiver(post_save, sender=Upvote)
def increment_upvote_count(sender, instance, created, **kwargs):
    if created:
        profile = instance.caregiver.caregiver_profile
        profile.upvote_count += 1
        profile.save()

@receiver(post_delete, sender=Upvote)
def decrement_upvote_count(sender, instance, **kwargs):
    try:
        # Try to get the profile
        profile = instance.caregiver.caregiver_profile

        # If successful, decrement the count
        if profile.upvote_count > 0:
            profile.upvote_count -= 1
            profile.save()

    except User.caregiver_profile.RelatedObjectDoesNotExist:
        # If the profile is already gone (which happens during deletion),
        # just do nothing. The count is being deleted anyway.
        pass