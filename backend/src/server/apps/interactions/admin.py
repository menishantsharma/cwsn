# apps/interactions/admin.py
from django.contrib import admin
from .models import ServiceRequest, Report, Upvote

@admin.register(ServiceRequest)
class ServiceRequestAdmin(admin.ModelAdmin):
    list_display = ('service', 'cwsn_user', 'caregiver', 'child', 'status')
    list_filter = ('status',)
    search_fields = ('cwsn_user__email', 'caregiver__email', 'service__title')
@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):
    # --- MODIFIED/ADDED LINES ---
    list_display = ('reported_user', 'reporter', 'region_of_incident', 'status', 'created_at')
    list_filter = ('status', 'region_of_incident', 'created_at') # Added created_at
    search_fields = ('reported_user__email', 'reporter__email')
    
    # Organize the admin view and show the new action field
    fieldsets = (
        ('Report Details (Read-Only)', {
            'fields': ('reporter', 'reported_user', 'region_of_incident', 'reason', 'created_at')
        }),
        ('Moderation', {
            'fields': ('status', 'moderator_action')
        }),
    )
    
    def get_readonly_fields(self, request, obj=None):
        """
        Makes key fields read-only after creation.
        """
        if obj: # obj is not None, so this is an existing report (change view)
            # --- MODIFIED/ADDED LINES ---
            return ['reporter', 'reported_user', 'region_of_incident', 'reason', 'created_at']
        return [] # On add view, all fields are editable
    # ---

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(region_of_incident_id__in=regions_pks)
        return qs.none()

admin.site.register(Upvote)