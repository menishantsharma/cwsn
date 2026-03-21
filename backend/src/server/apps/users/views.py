# apps/users/views.py
from rest_framework import viewsets, permissions
from .models import CWSNProfile, ChildProfile, CaregiverProfile
from .serializers import CWSNProfileSerializer, ChildProfileSerializer, CaregiverProfileSerializer
from allauth.socialaccount.providers.google.views import GoogleOAuth2Adapter
from allauth.socialaccount.providers.oauth2.client import OAuth2Client
from dj_rest_auth.registration.views import SocialLoginView

class GoogleLogin(SocialLoginView):
    adapter_class = GoogleOAuth2Adapter
    # The callback_url here is strictly for verification matching. 
    # It usually doesn't need to actually exist on the backend, 
    # but it MUST match the 'Authorized redirect URI' you set in Google Cloud Console.
    # If your frontend is localhost:3000, put that here.
    callback_url = "http://localhost:3000" 
    client_class = OAuth2Client

class IsOwnerOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow owners of an object to edit it.
    """
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        # Write permissions are only allowed to the owner of the profile.
        return obj.user == request.user

class CWSNProfileViewSet(viewsets.ModelViewSet):
    # queryset = CWSNProfile.active.all()
    serializer_class = CWSNProfileSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        return CWSNProfile.objects.filter(user=self.request.user)

class ChildProfileViewSet(viewsets.ModelViewSet):
    serializer_class = ChildProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # A parent can only see/edit their own children
        return ChildProfile.objects.filter(parent=self.request.user)

    def perform_create(self, serializer):
        # Automatically assign the parent on creation
        serializer.save(parent=self.request.user)

class CaregiverProfileViewSet(viewsets.ModelViewSet):
    # queryset = CaregiverProfile.objects.all()
    serializer_class = CaregiverProfileSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly]

    def get_queryset(self): # <-- ADD THIS METHOD
        """
        Return the correct queryset at runtime.
        """
        # For public list/detail views, use the filtered "active" manager
        if self.action in ['list', 'retrieve']:
            return CaregiverProfile.active.all()
        
        # For write actions, the queryset should be unfiltered
        # so the owner (who passes IsOwnerOrReadOnly) can edit it.
        return CaregiverProfile.objects.all()