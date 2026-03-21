# apps/users/admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, CWSNProfile, ChildProfile, CaregiverProfile, ModeratorProfile

# Imports for the inlines and new display field
from apps.services.models import Service
from django.urls import reverse
from django.utils.html import format_html

# --- ADDED THESE IMPORTS ---
from django import forms
from django.contrib import messages
# ---

# Unregister the default User admin
try:
    admin.site.unregister(User)
except admin.sites.NotRegistered:
    pass

# --- INLINE CLASSES (for the main User admin) ---
# These are still useful on the central User page

class CaregiverProfileInline(admin.StackedInline):
    """
    Lets you edit the CaregiverProfile from the User page.
    """
    model = CaregiverProfile
    can_delete = False
    verbose_name_plural = 'Caregiver Profile'
    
    def get_fieldsets(self, request, obj=None):
        moderator_fields = ('Moderation (Editable)', {
            'fields': ('region', 'is_verified', 'verification_notes', 'availability_status')
        })
        if request.user.is_superuser:
            all_fields = (None, {'fields': ('name', 'contact_no', 'age', 'gender', 'qualifications', 'recommendations')})
            return (all_fields, moderator_fields)
        if hasattr(request.user, 'moderator_profile'):
            return (moderator_fields,)
        return ()

    def get_readonly_fields(self, request, obj=None):
        if not request.user.is_superuser:
            return ('name', 'contact_no', 'age', 'gender', 'qualifications', 'recommendations')
        return ()

class ServiceInline(admin.TabularInline):
    """
    Shows a view-only list of services on the User page.
    """
    model = Service
    fk_name = 'caregiver' # Explicitly state the FK is to the User model
    extra = 0
    can_delete = False
    fields = ('title', 'region', 'category', 'is_active', 'edit_link')
    readonly_fields = ('title', 'region', 'category', 'is_active', 'edit_link')

    def edit_link(self, obj):
        if obj.pk:
            url = reverse('admin:services_service_change', args=(obj.pk,))
            return format_html('<a href="{}">Edit Service</a>', url)
        return "N/A"
    edit_link.short_description = 'Link'

    def has_add_permission(self, request, obj=None):
        return False
        
    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(region_id__in=regions_pks)
        return qs.none()

class CWSNProfileInline(admin.StackedInline):
    """
    This inline lets us view the CWSNProfile from the
    new 'CWSN Users' admin page. It is READ-ONLY for moderators.
    (Used on the superadmin User page)
    """
    model = CWSNProfile
    can_delete = False
    verbose_name_plural = 'CWSN User Profile (Read-Only for Moderators)'

    # Show all fields for everyone
    fieldsets = (
        (None, {
            'fields': ('name', 'age', 'gender', 'region')
        }),
    )

    def get_readonly_fields(self, request, obj=None):
        if request.user.is_superuser:
            # Superusers can edit everything
            return ()
        
        # ALL other users (including moderators) get read-only fields
        return ('name', 'age', 'gender', 'region')
        
    def has_change_permission(self, request, obj=None):
        # Allow superusers to change, deny everyone else
        return request.user.is_superuser

# --- ADMIN CLASSES ---

@admin.register(User)
class CustomUserAdmin(UserAdmin):
    """
    The central User admin.
    --- THIS IS HIDDEN FROM MODERATORS ---
    """
    base_fieldsets = UserAdmin.fieldsets
    role_fieldset = ('Role Management', {'fields': ('is_cwsn_user', 'is_caregiver', 'is_moderator')})
    suspension_fieldset = ('Suspension (Moderator)', {'fields': ('is_suspended', 'suspension_reason')})

    list_display = ['email', 'is_cwsn_user', 'is_caregiver', 'is_moderator', 'is_staff', 'is_suspended']
    list_filter = UserAdmin.list_filter + ('is_suspended', 'is_staff', 'is_cwsn_user', 'is_caregiver')
    search_fields = ['email', 'username']
    
    inlines = [CaregiverProfileInline, ServiceInline]

    def has_module_permission(self, request):
        """
        Only allow superusers to see the main "Users" list.
        """
        if request.user.is_superuser:
            return True
        return False

    def get_fieldsets(self, request, obj=None):
        if request.user.is_superuser:
            return self.base_fieldsets + (self.role_fieldset, self.suspension_fieldset)
        if hasattr(request.user, 'moderator_profile') and obj and obj.is_caregiver:
            user_info = ('User Info (Read-Only)', {'fields': ('email', 'first_name', 'last_name')})
            return (user_info, self.suspension_fieldset)
        return (self.suspension_fieldset,)
    
    def get_readonly_fields(self, request, obj=None):
        if not request.user.is_superuser:
            return ('email', 'first_name', 'last_name', 'date_joined', 'last_login')
        return super().get_readonly_fields(request, obj)
        
    def get_inlines(self, request, obj):
        if obj and obj.is_caregiver:
            return [CaregiverProfileInline, ServiceInline]
        if obj and obj.is_cwsn_user and request.user.is_superuser:
             return [CWSNProfileInline]
        return []

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(is_superuser=False) & \
                   qs.filter(caregiver_profile__region_id__in=regions_pks)
        return qs.none()

# --- CWSN PROFILE ADMIN ---

class CWSNProfileAdminForm(forms.ModelForm):
    """
    A custom form to add User fields (is_suspended, suspension_reason)
    to the CWSNProfile admin page.
    """
    is_suspended = forms.BooleanField(
        required=False, 
        label='Is Suspended',
        help_text="Hide user from listings and disable new requests."
    )
    suspension_reason = forms.CharField(
        required=False, 
        widget=forms.Textarea(attrs={'rows': 4}),
        label='Suspension Reason',
        help_text="Why the moderator suspended them (spam, fake info, etc.)"
    )

    class Meta:
        model = CWSNProfile
        fields = '__all__'

    def __init__(self, *args, **kwargs):
        """
        Populate the initial values for the extra fields
        from the related user object.
        """
        super().__init__(*args, **kwargs)
        if self.instance and self.instance.pk:
            # This is an existing object, get the user
            user = self.instance.user
            self.fields['is_suspended'].initial = user.is_suspended
            self.fields['suspension_reason'].initial = user.suspension_reason

@admin.register(CWSNProfile)
class CWSNProfileAdmin(admin.ModelAdmin):
    form = CWSNProfileAdminForm
    list_display = ('name', 'user_email', 'region', 'get_is_suspended')
    list_filter = ('region',)
    search_fields = ('name', 'user__email')
    
    def user_email(self, obj):
        return obj.user.email
    
    @admin.display(description='Is Suspended', boolean=True)
    def get_is_suspended(self, obj):
        return obj.user.is_suspended

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(region_id__in=regions_pks)
        return qs.none()

    # --- MODIFIED THIS METHOD ---
    def get_fieldsets(self, request, obj=None):
        """
        Show profile fields (read-only for mods)
        and suspension fields (editable for mods).
        """
        profile_fields = (
            'CWSN Profile (Read-Only for Moderators)', {
                'fields': ('name', 'age', 'gender', 'region')
            }
        )
        user_fields = (
            'User Account Info (Read-Only)', {
                'fields': ('user_email_display',) 
            }
        )
        suspension_fields = (
            'Suspension (Moderator)', {
                'fields': ('is_suspended', 'suspension_reason')
            }
        )
        
        # --- ADDED THIS FIELDSET ---
        children_fieldset = (
            'Children Profiles (View-Only)', {
                'fields': ('display_children',)
            }
        )
        # ---

        if request.user.is_superuser:
            superuser_profile_fields = (
                'CWSN Profile', {
                    'fields': ('user', 'name', 'age', 'gender', 'region')
                }
            )
            # --- MODIFIED THIS RETURN ---
            return (superuser_profile_fields, suspension_fields, children_fieldset)
        
        # --- MODIFIED THIS RETURN ---
        return (user_fields, profile_fields, suspension_fields, children_fieldset)
    
    # --- MODIFIED THIS METHOD ---
    def get_readonly_fields(self, request, obj=None):
        """
        Make profile fields read-only for moderators.
        Suspension fields are editable.
        """
        # --- ADD 'display_children' TO THE BASE LIST ---
        base_readonly = ['user_email_display', 'display_children']

        if request.user.is_superuser:
            # Superuser can edit everything *except* the display field
            # --- MODIFIED THIS RETURN ---
            return ['display_children']
        
        # Moderators get read-only profile fields
        base_readonly.extend(['user', 'name', 'age', 'gender', 'region'])
        return base_readonly
    
    @admin.display(description='User Email')
    def user_email_display(self, obj):
        if obj and obj.pk:
            return obj.user.email
        return "-"
    
    # --- ADDED THIS ENTIRE METHOD ---
    @admin.display(description='Children')
    def display_children(self, obj):
        """
        A custom method to render a list of children as HTML
        with links to their respective admin pages.
        """
        # 'obj' here is the CWSNProfile.
        # We get the user, then find children via the 'children' related_name
        children = obj.user.children.all()
        
        if not children.exists():
            return "No children listed for this user."
            
        html = "<ul>"
        for child in children:
            # --- Ensure you use the correct admin URL name: 'appname_modelname_change' ---
            url = reverse('admin:users_childprofile_change', args=(child.pk,))
            html += f"<li><a href='{url}'>{child.name}</a> (Age: {child.age})</li>"
        html += "</ul>"
        return format_html(html)
    # ---
    
    def has_change_permission(self, request, obj=None):
        return request.user.is_superuser or hasattr(request.user, 'moderator_profile')

    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser
    
    def save_model(self, request, obj, form, change):
        """
        When saving the CWSNProfile, also save the
        suspension data back to the related User model.
        """
        super().save_model(request, obj, form, change)
        user = obj.user
        is_suspended = form.cleaned_data.get('is_suspended')
        suspension_reason = form.cleaned_data.get('suspension_reason')
        user.is_suspended = is_suspended
        user.suspension_reason = suspension_reason
        user.save(update_fields=['is_suspended', 'suspension_reason'])
        
        self.message_user(request, "User suspension status updated successfully.", messages.SUCCESS)

# --- CAREGIVER PROFILE ADMIN ---

class CaregiverProfileAdminForm(forms.ModelForm):
    """
    A custom form to add User fields (is_suspended, suspension_reason)
    to the CaregiverProfile admin page.
    """
    is_suspended = forms.BooleanField(
        required=False, 
        label='Is Suspended',
        help_text="Hide user from listings and disable new requests."
    )
    suspension_reason = forms.CharField(
        required=False, 
        widget=forms.Textarea(attrs={'rows': 4}),
        label='Suspension Reason',
        help_text="Why the moderator suspended them (spam, fake info, etc.)"
    )

    class Meta:
        model = CaregiverProfile
        fields = '__all__'

    def __init__(self, *args, **kwargs):
        """
        Populate the initial values for the extra fields
        from the related user object.
        """
        super().__init__(*args, **kwargs)
        if self.instance and self.instance.pk:
            # This is an existing object, get the user
            user = self.instance.user
            self.fields['is_suspended'].initial = user.is_suspended
            self.fields['suspension_reason'].initial = user.suspension_reason

@admin.register(CaregiverProfile)
class CaregiverProfileAdmin(admin.ModelAdmin):
    """
    Custom Admin for Caregiver Profiles, filtered by region.
    Now includes suspension fields.
    """
    form = CaregiverProfileAdminForm
    list_display = ('name', 'user_email', 'region', 'is_verified', 'availability_status', 'get_is_suspended')
    list_filter = ('region', 'is_verified', 'availability_status')
    search_fields = ('name', 'user__email')

    def user_email(self, obj):
        return obj.user.email

    @admin.display(description='Is Suspended', boolean=True)
    def get_is_suspended(self, obj):
        return obj.user.is_suspended

    def get_fieldsets(self, request, obj=None):
        # Moderator-editable fields
        moderator_fields = (
            'Moderation (Editable)', {
                'fields': (
                    'region', 
                    'is_verified', 
                    'verification_notes', 
                    'availability_status'
                )
            }
        )
        
        # Moderator read-only fields
        readonly_fields_set = (
            'Caregiver Info (Read-Only)', {
                'fields': ('name', 'user_email_display', 'contact_no', 'age', 'gender', 'qualifications', 'recommendations')
            }
        )

        service_list_fieldset = (
            'Caregiver\'s Services (View-Only)', {
                'fields': ('display_services',)
            }
        )
        
        suspension_fieldset = (
            'Suspension (Moderator)', {
                'fields': ('is_suspended', 'suspension_reason')
            }
        )

        if request.user.is_superuser:
            # Admins see all fields and they are all editable
            superuser_fields = (None, {'fields': ('user', 'name', 'contact_no', 'age', 'gender', 'qualifications', 'recommendations')})
            return (superuser_fields, moderator_fields, suspension_fieldset, service_list_fieldset)
        
        if hasattr(request.user, 'moderator_profile'):
            # Moderators see their allowed fields + the service list
            return (readonly_fields_set, moderator_fields, suspension_fieldset, service_list_fieldset)
        
        return ()
    
    def get_readonly_fields(self, request, obj=None):
        # Base readonly fields
        readonly = ['display_services'] 
        
        if request.user.is_superuser:
            return readonly # Superuser can edit all but this
            
        if hasattr(request.user, 'moderator_profile'):
             # Moderators can only edit fields from 'moderator_fields' and 'suspension_fieldset'
            readonly.extend(['name', 'user_email_display', 'user', 'contact_no', 'age', 'gender', 'qualifications', 'recommendations'])
        
        return readonly

    @admin.display(description='User Email')
    def user_email_display(self, obj):
        if obj and obj.pk:
            return obj.user.email
        return "-"

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(region_id__in=regions_pks)
        return qs.none()

    def display_services(self, obj):
        """
        A custom method to render a list of services as HTML
        with links to their respective admin pages.
        """
        services = obj.user.services.all()
        
        if not services.exists():
            return "No services listed for this caregiver."
            
        html = "<ul>"
        for service in services:
            url = reverse('admin:services_service_change', args=(service.pk,))
            status = 'Active' if service.is_active else 'Inactive'
            html += f"<li><a href='{url}'>{service.title}</a> ({status} - {service.region.name})</li>"
        html += "</ul>"
        return format_html(html)
    
    display_services.short_description = 'Services'

    def save_model(self, request, obj, form, change):
        """
        When saving the CaregiverProfile, also save the
        suspension data back to the related User model.
        """
        # 1. Save the CaregiverProfile object
        super().save_model(request, obj, form, change)

        # 2. Get the related user
        user = obj.user
        
        # 3. Get the data from the form's cleaned_data
        is_suspended = form.cleaned_data.get('is_suspended')
        suspension_reason = form.cleaned_data.get('suspension_reason')

        # 4. Update the user object
        user.is_suspended = is_suspended
        user.suspension_reason = suspension_reason
        user.save(update_fields=['is_suspended', 'suspension_reason'])
        
        self.message_user(request, "User suspension status updated successfully.", messages.SUCCESS)

@admin.register(ChildProfile)
class ChildProfileAdmin(admin.ModelAdmin):
    list_display = ('name', 'parent_email', 'age')
    search_fields = ('name', 'parent__email')
    
    def parent_email(self, obj):
        return obj.parent.email
    
    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            regions_pks = request.user.moderator_profile.get_accessible_region_pks()
            return qs.filter(parent__cwsn_profile__region_id__in=regions_pks)
        return qs.none()

@admin.register(ModeratorProfile)
class ModeratorProfileAdmin(admin.ModelAdmin):
    list_display = ('user_email',)
    search_fields = ('user__email',)
    filter_horizontal = ('regions',) 

    def user_email(self, obj):
        return obj.user.email
    
    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        if hasattr(request.user, 'moderator_profile'):
            return qs.filter(user=request.user)
        return qs.none()