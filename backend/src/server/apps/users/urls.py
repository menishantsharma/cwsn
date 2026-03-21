# apps/users/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'cwsn-profiles', views.CWSNProfileViewSet, basename='cwsnprofile')
router.register(r'child-profiles', views.ChildProfileViewSet, basename='childprofile')
router.register(r'caregiver-profiles', views.CaregiverProfileViewSet, basename='caregiverprofile')

urlpatterns = [
    path('', include(router.urls)),
    path('auth/google/', views.GoogleLogin.as_view(), name='google_login'),
]