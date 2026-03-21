# apps/users/models.py
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from apps.common.models import Region

# --- ADD THESE IMPORTS ---
from django.db.models.signals import post_save
from django.dispatch import receiver
from apps.services.models import Service
# ---

class User(AbstractUser):
    # Use email as the primary identifier
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, blank=True) # Keep for admin, but not for login

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username'] # 'username' is still required for createsuperuser

    # Role booleans
    is_cwsn_user = models.BooleanField(default=False)
    is_caregiver = models.BooleanField(default=False)
    is_moderator = models.BooleanField(default=False)
    is_suspended = models.BooleanField(
        default=False, 
        help_text="Hide user from listings and disable new requests."
    )
    suspension_reason = models.TextField(
        blank=True, 
        null=True,
        help_text="Why the moderator suspended them (spam, fake info, etc.)"
    )

    def __str__(self):
        return self.email

class ActiveCaregiverManager(models.Manager):
    """
    A custom manager that returns only active, non-suspended caregivers.
    """
    def get_queryset(self):
        return super().get_queryset().filter(
            user__is_suspended=False,
            is_verified=True  # You probably only want to show verified caregivers
        )

class CWSNProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='cwsn_profile')
    name = models.CharField(max_length=255)
    age = models.PositiveIntegerField()
    gender = models.CharField(max_length=10, choices=[('Male', 'Male'), ('Female', 'Female'), ('Other', 'Other')])
    region = models.ForeignKey('common.Region', on_delete=models.SET_NULL, null=True, blank=True, related_name='cwsn_users')
    
    def __str__(self):
        return f"{self.name}'s CWSN Profile"

class ChildProfile(models.Model):
    parent = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='children')
    name = models.CharField(max_length=255)
    age = models.PositiveIntegerField()
    gender = models.CharField(max_length=10, choices=[('Male', 'Male'), ('Female', 'Female'), ('Other', 'Other')])
    disabilities = models.ManyToManyField('common.Disability', blank=True)

    def __str__(self):
        return f"{self.name} (Child of {self.parent.email})"

class CaregiverProfile(models.Model):
    AVAILABILITY_CHOICES = [
        ('Available', 'Available'),
        ('Busy', 'Busy'),
    ]
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='caregiver_profile')
    name = models.CharField(max_length=255)
    contact_no = models.CharField(max_length=20) # This will be hidden
    age = models.PositiveIntegerField()
    gender = models.CharField(max_length=10, choices=[('Male', 'Male'), ('Female', 'Female'), ('Other', 'Other')])
    region = models.ForeignKey('common.Region', on_delete=models.SET_NULL, null=True, blank=True, related_name='caregivers')
    qualifications = models.TextField(blank=True)
    recommendations = models.TextField(blank=True)
    upvote_count = models.PositiveIntegerField(default=0)
    languages = models.ManyToManyField('common.Language', blank=True)
    
    is_verified = models.BooleanField(
        default=False,
        help_text="Moderator has verified this caregiver's qualifications."
    )
    verification_notes = models.TextField(
        blank=True, 
        null=True,
        help_text="Comments about verification (optional)."
    )
    availability_status = models.CharField(
        max_length=20,
        choices=AVAILABILITY_CHOICES,
        default='Available',
        help_text="Caregiver's current availability status."
    )
    objects = models.Manager()  # The default manager
    active = ActiveCaregiverManager() # Our new, filtered manager

    def __str__(self):
        return f"{self.name}'s Caregiver Profile"

class ModeratorProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='moderator_profile')
    regions = models.ManyToManyField('common.Region', related_name='moderators')

    def __str__(self):
        return f"{self.user.email}'s Moderator Profile"

    def get_accessible_region_pks(self):
        """
        Returns a set of all Region PKs this moderator can access,
        including their assigned regions and all descendants (children,
        grandchildren, etc.).
        """
        # 1. Get the base regions assigned to the moderator
        base_regions = self.regions.all()
        base_region_pks = set(base_regions.values_list('pk', flat=True))
        
        if not base_region_pks:
            return set()

        # 2. Get all regions to build an in-memory map for traversal
        all_regions_data = Region.objects.values('pk', 'parent_id')
        
        parent_map = {} 
        for region_data in all_regions_data:
            parent_pk = region_data['parent_id']
            child_pk = region_data['pk']
            if parent_pk not in parent_map:
                parent_map[parent_pk] = []
            parent_map[parent_pk].append(child_pk)
        
        # 3. Use a queue (a list) to perform a breadth-first search
        accessible_pks = set(base_region_pks)
        queue = list(base_region_pks)
        
        while queue:
            current_pk = queue.pop(0)
            
            # Find all children of the current region from our map
            children_pks = parent_map.get(current_pk, [])
            
            for child_pk in children_pks:
                if child_pk not in accessible_pks:
                    accessible_pks.add(child_pk)
                    queue.append(child_pk)
                    
        return accessible_pks

# --- ADD THIS NEW SIGNAL RECEIVER ---

@receiver(post_save, sender=User)
def handle_caregiver_suspension(sender, instance, created, update_fields, **kwargs):
    """
    When a Caregiver's User account is suspended, deactivate all their services.
    """
    # Only act on existing caregivers
    if not created and instance.is_caregiver:
        # Check if 'is_suspended' was one of the fields updated
        # This is how the admin saves, so it's a reliable check
        if update_fields and 'is_suspended' in update_fields:
            if instance.is_suspended:
                # The user was just suspended, deactivate all their services.
                # We can do this without importing Service by using the related_name
                instance.services.all().update(is_active=False)
            # else:
                # User was unsuspended. We will NOT reactivate services automatically.
                # This should be a manual action by the caregiver.