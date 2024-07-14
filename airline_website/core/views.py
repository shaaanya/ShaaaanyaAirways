from django.http import JsonResponse
from django.shortcuts import render
from .models import Promotion

# Create your views here.
def home(request):
    return render(request, 'home.html')


def about(request):
    return render(request, "about.html")

def discover(request):
    return render(request, "discover.html")

def book(request):
    return render(request, "book.html")

def airportmap(request):
    return render(request, "airportmap.html")

def account(request):
    return render(request, "account.html")

def promotions_data(request):
    promotions = Promotion.objects.all()
    promotions_list = [{
        "promotion_name": promo.promotion_name,
        "route": promo.route.name,  # Assuming 'name' is a field in Route model
        "promotion_code": promo.promotion_code,
        "promotion_discount": float(promo.promotion_discount),  # Convert Decimal to float for JSON serialization
        "promotion_start_date": promo.promotion_start_date.strftime('%Y-%m-%d'),
        "promotion_end_date": promo.promotion_end_date.strftime('%Y-%m-%d'),
        "image_url": promo.image_url
    } for promo in promotions]
    return JsonResponse(promotions_list, safe=False)