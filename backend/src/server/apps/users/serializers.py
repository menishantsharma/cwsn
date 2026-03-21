# apps/users/serializers.py
from rest_framework import serializers
from .models import User, CWSNProfile, ChildProfile, CaregiverProfile
from apps.interactions.models import ServiceRequest

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'is_cwsn_user', 'is_caregiver', 'is_moderator']

class ChildProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChildProfile
        fields = '__all__'

class CWSNProfileSerializer(serializers.ModelSerializer):
    children = ChildProfileSerializer(many=True, read_only=True)
    
    class Meta:
        model = CWSNProfile
        fields = ['id', 'user', 'name', 'age', 'gender', 'children']

class CaregiverProfileSerializer(serializers.ModelSerializer):
    contact_no = serializers.SerializerMethodField()
    region_name = serializers.CharField(source='region.name', read_only=True)
    languages = serializers.StringRelatedField(many=True, read_only=True)

    class Meta:
        model = CaregiverProfile
        fields = [
            'id', 'user', 'name', 'age', 'gender', 'region', 'region_name', 
            'qualifications', 'recommendations', 'upvote_count', 
            'languages', 'contact_no'
        ]

    def get_contact_no(self, profile_obj):
        """
        Hides contact number unless the requesting user has an
        accepted request with this caregiver. Also shows a pending message.
        """
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return "Hidden (Login required)"

        requesting_user = request.user

        # Allow user to see their own number
        if profile_obj.user == requesting_user:
            return profile_obj.contact_no

        # Fetch all requests between this parent and caregiver
        user_requests = ServiceRequest.objects.filter(
            cwsn_user=requesting_user,
            caregiver=profile_obj.user
        )

        # 1. If ANY request is accepted, show the number
        if user_requests.filter(status='Accepted').exists():
            return profile_obj.contact_no

        # 2. If no request is accepted, but one is pending, show the pending message
        if user_requests.filter(status='Pending').exists():
            return "Hidden (Request pending caregiver approval)"

        # 3. If there are no requests, or they were all rejected, tell them to send one
        return "Hidden (Send request to view)"