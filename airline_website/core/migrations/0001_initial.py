# Generated by Django 4.2.14 on 2024-07-13 14:47

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Admin",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("login_name", models.CharField(max_length=255)),
                ("name", models.CharField(max_length=255)),
                ("password", models.CharField(max_length=255)),
                ("email", models.EmailField(max_length=255)),
                ("phone_number", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Aircraft",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("aircraft_name", models.CharField(max_length=255)),
                ("aircraft_type", models.CharField(max_length=255)),
                ("aircraft_status", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Airport",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("airport_name", models.CharField(max_length=255)),
                ("airport_code", models.CharField(max_length=8)),
                ("airport_location", models.CharField(max_length=255)),
                ("airport_status", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Booking",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("booking_date", models.DateField()),
                ("booking_status", models.CharField(max_length=255)),
                ("seat_type", models.CharField(max_length=255)),
                ("seat_number", models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name="Pilot",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("first_name", models.CharField(max_length=255)),
                ("last_name", models.CharField(max_length=255)),
                ("email", models.EmailField(max_length=255)),
                ("phone_number", models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name="Promotion",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("destination", models.CharField(max_length=100)),
                ("dates", models.CharField(max_length=100)),
                ("price", models.CharField(max_length=20)),
                ("image_url", models.URLField()),
            ],
        ),
        migrations.CreateModel(
            name="RegisteredUser",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("first_name", models.CharField(max_length=255)),
                ("last_name", models.CharField(max_length=255)),
                ("login_name", models.CharField(max_length=255)),
                ("password", models.CharField(max_length=255)),
                ("email", models.EmailField(max_length=255)),
                ("phone_number", models.CharField(max_length=255)),
                (
                    "gender",
                    models.CharField(
                        choices=[("Male", "Male"), ("Female", "Female")], max_length=255
                    ),
                ),
                (
                    "user_type",
                    models.CharField(
                        choices=[("User", "User"), ("Admin", "Admin")], max_length=20
                    ),
                ),
                ("reg_date", models.DateField()),
                ("last_login", models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name="Ticket",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("ticket_number", models.CharField(max_length=255)),
                ("ticket_status", models.CharField(max_length=255)),
                (
                    "booking",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="core.booking"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Route",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("route_name", models.CharField(max_length=255)),
                ("distance", models.DecimalField(decimal_places=2, max_digits=10)),
                ("duration", models.TimeField()),
                ("route_status", models.CharField(max_length=255)),
                (
                    "arrival_airport",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="arrival_routes",
                        to="core.airport",
                    ),
                ),
                (
                    "departure_airport",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="departure_routes",
                        to="core.airport",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Payment",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("payment_date", models.DateField()),
                ("payment_status", models.CharField(max_length=255)),
                (
                    "payment_amount",
                    models.DecimalField(decimal_places=2, max_digits=10),
                ),
                (
                    "booking",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="core.booking"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Flight",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("flight_number", models.CharField(max_length=255)),
                ("economy_seats_available", models.IntegerField()),
                ("business_seats_available", models.IntegerField()),
                ("first_class_seats_available", models.IntegerField()),
                (
                    "economy_class_fare",
                    models.DecimalField(decimal_places=2, max_digits=10),
                ),
                (
                    "business_class_fare",
                    models.DecimalField(decimal_places=2, max_digits=10),
                ),
                (
                    "first_class_fare",
                    models.DecimalField(decimal_places=2, max_digits=10),
                ),
                (
                    "aircraft",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="core.aircraft"
                    ),
                ),
                (
                    "pilot",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="core.pilot"
                    ),
                ),
                (
                    "route",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="core.route"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Feedback",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("feedback_date", models.DateField()),
                ("feedback_message", models.TextField()),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="core.registereduser",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Complaint",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("complaint_date", models.DateField()),
                ("complaint_message", models.TextField()),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="core.registereduser",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="booking",
            name="flight",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="core.flight"
            ),
        ),
        migrations.AddField(
            model_name="booking",
            name="user",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to="core.registereduser"
            ),
        ),
    ]
