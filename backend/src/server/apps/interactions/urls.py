# apps/interactions/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'requests', views.ServiceRequestViewSet, basename='servicerequest')
router.register(r'reports', views.ReportViewSet, basename='report')
router.register(r'upvotes', views.UpvoteViewSet, basename='upvote')

urlpatterns = [
    path('', include(router.urls)),
]