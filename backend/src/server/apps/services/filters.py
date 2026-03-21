# apps/services/filters.py
import django_filters
from .models import Service
from apps.users.models import CaregiverProfile

class ServiceFilter(django_filters.FilterSet):
    # Filter by fields on the Service model
    category = django_filters.NumberFilter(field_name='category__id')
    service_type = django_filters.ChoiceFilter(choices=Service.SERVICE_TYPES)
    payment_type = django_filters.ChoiceFilter(choices=Service.PAYMENT_TYPES)
    target_gender = django_filters.ChoiceFilter(choices=Service.GENDER_TARGETS)
    
    # Filter by caregiver's region
    region = django_filters.NumberFilter(field_name='caregiver__caregiver_profile__region__id')
    
    # Filter by age (less than or equal to max, greater than or equal to min)
    age = django_filters.NumberFilter(field_name='target_age_max', lookup_expr='gte')

    class Meta:
        model = Service
        fields = ['category', 'service_type', 'payment_type', 'target_gender', 'region', 'age']