# apps/interactions/serializers.py
from rest_framework import serializers
from .models import ServiceRequest, Report, Upvote

class ServiceRequestSerializer(serializers.ModelSerializer):
    service_title = serializers.CharField(source='service.title', read_only=True)
    child_name = serializers.CharField(source='child.name', read_only=True)
    cwsn_user_email = serializers.EmailField(source='cwsn_user.email', read_only=True)
    caregiver_email = serializers.EmailField(source='caregiver.email', read_only=True)

    class Meta:
        model = ServiceRequest
        fields = [
            'id', 'service', 'service_title', 'child', 'child_name', 
            'cwsn_user', 'cwsn_user_email', 'caregiver', 'caregiver_email', 
            'status', 'created_at'
        ]
        read_only_fields = ('cwsn_user', 'caregiver', 'status')

class ReportSerializer(serializers.ModelSerializer):
    reporter_email = serializers.EmailField(source='reporter.email', read_only=True)
    reported_user_email = serializers.EmailField(source='reported_user.email', read_only=True)

    class Meta:
        model = Report
        fields = [
            'id', 'reporter', 'reporter_email', 'reported_user', 
            'reported_user_email', 'reason', 'region_of_incident', 
            'status', 'created_at'
        ]
        read_only_fields = ('reporter', 'region_of_incident', 'status')

class UpvoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Upvote
        fields = ['id', 'voter', 'caregiver', 'created_at']
        read_only_fields = ('voter',)