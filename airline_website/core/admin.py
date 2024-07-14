from django.contrib import admin
from core.models import *

# Register all models from core.models
admin.site.register(Admin)
admin.site.register(RegisteredUser)
admin.site.register(Airport)
admin.site.register(Route)
admin.site.register(Aircraft)
admin.site.register(Pilot)
admin.site.register(Flight)
admin.site.register(Booking)
admin.site.register(Ticket)
admin.site.register(Payment)
admin.site.register(Feedback)
admin.site.register(Complaint)
admin.site.register(Promotion)
