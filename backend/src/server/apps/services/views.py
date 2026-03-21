# apps/services/views.py
from django.db.models import Q
from rest_framework import viewsets, permissions, status, decorators
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from .models import Service, AvailabilitySlot
from .serializers import ServiceSerializer, AvailabilitySlotSerializer
from .filters import ServiceFilter

class IsCaregiverOwnerOrReadOnly(permissions.BasePermission):
    """
    Custom permission:
    - Safe methods (GET, HEAD, OPTIONS) allowed for everyone.
    - Write permissions only for the caregiver who owns the object.
    """
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        # Write permissions only for the caregiver who owns this service
        return obj.caregiver == request.user

class ServiceViewSet(viewsets.ModelViewSet):
    serializer_class = ServiceSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsCaregiverOwnerOrReadOnly]
    filterset_class = ServiceFilter
    # ADDED: Parsers to handle Image Uploads (multipart/form-data)
    parser_classes = (MultiPartParser, FormParser)

    def get_queryset(self):
        """
        Logic:
        1. Public/Clients see ONLY active services.
        2. Caregivers should see active services AND their own inactive services (to edit them).
        """
        user = self.request.user
        
        # Base active services
        qs = Service.active.all()

        # If user is a caregiver, include their own services (even if inactive/suspended)
        # Note: We use the default manager 'objects' for the user's own services
        if user.is_authenticated and hasattr(user, 'is_caregiver') and user.is_caregiver:
            my_services = Service.objects.filter(caregiver=user)
            # Union of public active services + my own services
            qs = qs | my_services
            
        return qs.distinct()

    def perform_create(self, serializer):
        # Only caregivers can create services
        # (Authentication checks handled by permissions, but role check here)
        if not getattr(self.request.user, 'is_caregiver', False):
            raise permissions.PermissionDenied("You must be a caregiver to create a service.")
        
        # User is automatically assigned as caregiver
        serializer.save(caregiver=self.request.user)

class AvailabilitySlotViewSet(viewsets.ModelViewSet):
    serializer_class = AvailabilitySlotSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsCaregiverOwnerOrReadOnly]

    def get_queryset(self):
        """
        Frontend usage: /api/slots/?service=1
        """
        queryset = AvailabilitySlot.objects.all()
        
        # Filter by service if provided in query params
        service_id = self.request.query_params.get('service')
        if service_id:
            queryset = queryset.filter(service_id=service_id)
            
        # Optional: Hide booked slots from public list?
        # if self.action == 'list':
        #     queryset = queryset.filter(is_booked=False)
            
        return queryset

    def perform_create(self, serializer):
        # Ensure the user creating the slot owns the service
        service = serializer.validated_data.get('service')
        if service and service.caregiver != self.request.user:
             raise permissions.PermissionDenied("You can only add slots to your own services.")
        serializer.save(caregiver=self.request.user)

    @decorators.action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def book(self, request, pk=None):
        """
        Custom endpoint to book a slot.
        URL: POST /api/slots/{id}/book/
        """
        slot = self.get_object()
        
        if slot.is_booked:
            return Response({'detail': 'This slot is already booked.'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Authentication note: You might want to log who booked this.
        # Since the current model doesn't have a 'client' field, we just toggle the flag.
        slot.is_booked = True
        slot.save()
        
        return Response({'status': 'booked', 'slot_id': slot.id}, status=status.HTTP_200_OK)