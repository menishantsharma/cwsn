# apps/common/views.py
from rest_framework import viewsets
from .models import Region, ServiceCategory, Disability, Language
from .serializers import RegionSerializer, ServiceCategorySerializer, DisabilitySerializer, LanguageSerializer

# These are simple read-only viewsets for the app to get filter options
class RegionViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Region.objects.all()
    serializer_class = RegionSerializer

class ServiceCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ServiceCategory.objects.all()
    serializer_class = ServiceCategorySerializer

class DisabilityViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Disability.objects.all()
    serializer_class = DisabilitySerializer

class LanguageViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Language.objects.all()
    serializer_class = LanguageSerializer