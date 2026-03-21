# apps/common/admin.py
from django.contrib import admin
from .models import Region, ServiceCategory, Disability, Language

@admin.register(Region)
class RegionAdmin(admin.ModelAdmin):
    list_display = ('name', 'parent')
    search_fields = ('name',)
    list_filter = ('parent',)

admin.site.register(ServiceCategory)
admin.site.register(Disability)
admin.site.register(Language)