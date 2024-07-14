from django.db import models

# Admin model
class Admin(models.Model):
    login_name = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    email = models.EmailField(max_length=255)
    phone_number = models.CharField(max_length=255)

    def __str__(self):
        return self.name

# RegisteredUser model
class RegisteredUser(models.Model):
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
    ]

    USER_TYPE_CHOICES = [
        ('User', 'User'),
        ('Admin', 'Admin'),
    ]

    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    login_name = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    email = models.EmailField(max_length=255)
    phone_number = models.CharField(max_length=255)
    gender = models.CharField(max_length=255, choices=GENDER_CHOICES)
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES)
    reg_date = models.DateField()
    last_login = models.DateField()

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

# Locations model
class Location(models.Model):
    location_name = models.CharField(max_length=255)
    location_image = models.BinaryField()

    def __str__(self):
        return self.location_name

# Airport model
class Airport(models.Model):
    airport_name = models.CharField(max_length=255)
    airport_code = models.CharField(max_length=8)
    airport_location = models.ForeignKey(Location, on_delete=models.CASCADE)
    airport_lattitude = models.DecimalField(max_digits=10, decimal_places=6, default=0.0)
    airport_longitude = models.DecimalField(max_digits=10, decimal_places=6, default=0.0)
    airport_status = models.CharField(max_length=255)

    def __str__(self):
        return self.airport_name

# Aircraft model
class Aircraft(models.Model):
    aircraft_name = models.CharField(max_length=255)
    aircraft_type = models.CharField(max_length=255)
    aircraft_status = models.CharField(max_length=255)

    def __str__(self):
        return self.aircraft_name

# Pilot model
class Pilot(models.Model):
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField(max_length=255)
    phone_number = models.CharField(max_length=255)
    availiabe = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

# PilotAvailability model
class PilotAvailability(models.Model):
    pilot = models.ForeignKey(Pilot, on_delete=models.CASCADE)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()

# Route model
class Route(models.Model):
    route_name = models.CharField(max_length=255)
    departure_airport = models.ForeignKey(Airport, related_name='departure_routes', on_delete=models.CASCADE)
    arrival_airport = models.ForeignKey(Airport, related_name='arrival_routes', on_delete=models.CASCADE)
    distance = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    duration = models.TimeField()
    route_status = models.CharField(max_length=255)

    def __str__(self):
        return self.route_name

# Promotion model
class Promotion(models.Model):
    promotion_name = models.CharField(max_length=255, default='N/A')
    route = models.ForeignKey(Route, on_delete=models.CASCADE, default=0)
    promotion_code = models.CharField(max_length=255, default='N/A')
    promotion_discount = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    promotion_start_date = models.DateField(default='2023-01-01')
    promotion_end_date = models.DateField(default='2023-01-01')
    image_url = models.URLField(max_length=200, default='https://via.placeholder.com/300x200')  # Add default image URL

    def __str__(self):
        return self.promotion_name

# Flight model
class Flight(models.Model):
    flight_number = models.CharField(max_length=255)
    route = models.ForeignKey(Route, on_delete=models.CASCADE)
    departure_time = models.DateTimeField(default='2023-01-01 00:00:00')
    arrival_time = models.DateTimeField(default='2023-01-01 00:00:00')
    economy_seats_available = models.IntegerField()
    business_seats_available = models.IntegerField()
    first_class_seats_available = models.IntegerField()
    economy_class_fare = models.DecimalField(max_digits=10, decimal_places=2)
    business_class_fare = models.DecimalField(max_digits=10, decimal_places=2)
    first_class_fare = models.DecimalField(max_digits=10, decimal_places=2)
    aircraft = models.ForeignKey(Aircraft, on_delete=models.CASCADE)
    pilot = models.ForeignKey(Pilot, on_delete=models.CASCADE)

    def __str__(self):
        return self.flight_number

# Booking model
class Booking(models.Model):
    user = models.ForeignKey(RegisteredUser, on_delete=models.CASCADE)
    flight = models.ForeignKey(Flight, on_delete=models.CASCADE)
    booking_date = models.DateField()
    booking_status = models.CharField(max_length=255)
    seat_type = models.CharField(max_length=255)
    seat_number = models.IntegerField()

    def __str__(self):
        return f"Booking {self.id} for {self.user}"

# Ticket model
class Ticket(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    ticket_number = models.CharField(max_length=255)
    ticket_status = models.CharField(max_length=255)

    def __str__(self):
        return self.ticket_number

# Payment model
class Payment(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    payment_date = models.DateField()
    payment_status = models.CharField(max_length=255)
    payment_amount = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Payment {self.id} for booking {self.booking.id}"

# Feedback model
class Feedback(models.Model):
    user = models.ForeignKey(RegisteredUser, on_delete=models.CASCADE)
    feedback_date = models.DateField()
    feedback_message = models.TextField()

    def __str__(self):
        return f"Feedback {self.id} from {self.user}"

# Complaint model
class Complaint(models.Model):
    user = models.ForeignKey(RegisteredUser, on_delete=models.CASCADE)
    complaint_date = models.DateField()
    complaint_message = models.TextField()

    def __str__(self):
        return f"Complaint {self.id} from {self.user}"
