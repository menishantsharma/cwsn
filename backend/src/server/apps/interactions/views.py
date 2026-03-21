# apps/interactions/views.py
from django.forms import ValidationError
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import serializers
from .models import ServiceRequest, Report, Upvote
from .serializers import ServiceRequestSerializer, ReportSerializer, UpvoteSerializer
from .permissions import IsModeratorInRegion
from rest_framework.exceptions import PermissionDenied
from apps.services.models import Service

class ServiceRequestViewSet(viewsets.ModelViewSet):
    serializer_class = ServiceRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.is_cwsn_user:
            # CWSN users see requests they sent
            return ServiceRequest.objects.filter(cwsn_user=user)
        if user.is_caregiver:
            # Caregivers see requests they received
            return ServiceRequest.objects.filter(caregiver=user)
        return ServiceRequest.objects.none()
    
    def perform_create(self, serializer):
        # CWSN user sends a request
        if not self.request.user.is_cwsn_user:
            raise PermissionDenied("Only CWSN users can send requests.")
        
        service = serializer.validated_data.get('service')
        child = serializer.validated_data.get('child')
        
        if service.caregiver.is_suspended:
            raise PermissionDenied("This caregiver is suspended and cannot receive new requests.")
            
        # Manually check the unique constraint before hitting the database
        if ServiceRequest.objects.filter(cwsn_user=self.request.user, child=child, service=service).exists():
            # Using serializers.ValidationError since 'serializers' is already imported
            raise serializers.ValidationError({"non_field_errors": ["A request for this child and service already exists."]})

        caregiver = service.caregiver
        
        # Only ONE save line here!
        serializer.save(cwsn_user=self.request.user, caregiver=caregiver)

    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def accept(self, request, pk=None):
        service_request = self.get_object()
        # Only the caregiver can accept
        if request.user != service_request.caregiver:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
        
        service_request.status = 'Accepted'
        service_request.save()
        return Response(ServiceRequestSerializer(service_request).data)

    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def reject(self, request, pk=None):
        service_request = self.get_object()
        # Caregiver or CWSN user (who sent it) can reject/cancel
        if request.user not in [service_request.caregiver, service_request.cwsn_user]:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
        
        service_request.status = 'Rejected'
        service_request.save()
        return Response(ServiceRequestSerializer(service_request).data)

class ReportViewSet(viewsets.ModelViewSet):
    serializer_class = ReportSerializer
    permission_classes = [permissions.IsAuthenticated] # Base permission
    
    def get_permissions(self):
        # Only moderators/admins can 'update', 'partial_update', 'destroy'
        if self.action in ['update', 'partial_update', 'destroy']:
            self.permission_classes = [permissions.IsAdminUser | IsModeratorInRegion]
        return super().get_permissions()

    def get_queryset(self):
        user = self.request.user
        if user.is_superuser:
            return Report.objects.all() # Admin sees all
        if user.is_moderator:
            # Moderator sees reports in their assigned regions
            regions = user.moderator_profile.regions.all()
            return Report.objects.filter(region_of_incident__in=regions)
        if user.is_authenticated:
            # Regular users only see reports they filed
            return Report.objects.filter(reporter=user)
        return Report.objects.none()
    
    def perform_create(self, serializer):
        serializer.save(reporter=self.request.user)

class UpvoteViewSet(viewsets.ModelViewSet):
    serializer_class = UpvoteSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # Users only see upvotes they have given
        return Upvote.objects.filter(voter=self.request.user)

    def perform_create(self, serializer):
        # Only CWSN users can upvote
        if not self.request.user.is_cwsn_user:
            raise permissions.PermissionDenied("Only CWSN users can upvote caregivers.")
        
        caregiver_user = serializer.validated_data.get('caregiver')
        if not caregiver_user.is_caregiver:
             raise serializers.ValidationError("You can only upvote a caregiver.")

        # Check for duplicate
        if Upvote.objects.filter(voter=self.request.user, caregiver=caregiver_user).exists():
            raise serializers.ValidationError("You have already upvoted this caregiver.")

        serializer.save(voter=self.request.user)