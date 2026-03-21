# cwsn_backend/urls.py
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # Admin Portal (for Admins and Moderators)
    path('admin/', admin.site.urls),

    # API endpoints
    path('api/users/', include('apps.users.urls')),
    path('api/common/', include('apps.common.urls')),
    path('api/services/', include('apps.services.urls')),
    path('api/interactions/', include('apps.interactions.urls')),

    # Allauth URLs for social login
    path('accounts/', include('allauth.urls')),
    
    # Auth endpoints for Flutter (login, logout, register)
    # dj-rest-auth is great for this, but for now we'll use allauth's
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)