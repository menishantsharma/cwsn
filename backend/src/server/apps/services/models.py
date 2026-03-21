# apps/services/models.py
from django.db import models
from django.conf import settings

class ActiveServiceManager(models.Manager):
    """
    A custom manager that returns only active services from
    non-suspended, verified caregivers.
    """
    def get_queryset(self):
        return super().get_queryset().filter(
            is_active=True,
            caregiver__is_suspended=False,
            caregiver__caregiver_profile__is_verified=True
        )

class Service(models.Model):
    SERVICE_TYPES = [('Online', 'Online'), ('Offline', 'Offline'), ('Hybrid', 'Hybrid')]
    PAYMENT_TYPES = [('Paid', 'Paid'), ('Unpaid', 'Unpaid')]
    GENDER_TARGETS = [('Male', 'Male'), ('Female', 'Female'), ('Any', 'Any')]

    caregiver = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='services')
    category = models.ForeignKey('common.ServiceCategory', on_delete=models.SET_NULL, null=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    image = models.ImageField(upload_to='service_images/', null=True, blank=True)
    is_active = models.BooleanField(default=True)
    region = models.ForeignKey('common.Region', on_delete=models.SET_NULL, null=True, blank=True, related_name='services')
    
    # Filter fields
    service_type = models.CharField(max_length=10, choices=SERVICE_TYPES)
    payment_type = models.CharField(max_length=10, choices=PAYMENT_TYPES)
    max_participants = models.PositiveIntegerField(null=True, blank=True)
    target_age_min = models.PositiveIntegerField(null=True, blank=True)
    target_age_max = models.PositiveIntegerField(null=True, blank=True)
    target_gender = models.CharField(max_length=10, choices=GENDER_TARGETS, default='Any')
    target_disabilities = models.ManyToManyField('common.Disability', blank=True)
    
    objects = models.Manager() # The default manager
    active = ActiveServiceManager() # Our new, filtered manager

    def __str__(self):
        return self.title

class AvailabilitySlot(models.Model):
    caregiver = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='availability_slots')
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name='slots', null=True, blank=True)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    is_booked = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.caregiver.email} slot for {self.service.title}"