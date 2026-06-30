from app.services.place_service import place_service
from app.services.trip_service import trip_service
from app.services.favorite_service import favorite_service
from app.services.recommendation_service import recommendation_service
from app.services.route_service import route_service


def get_place_service():
    return place_service


def get_trip_service():
    return trip_service


def get_favorite_service():
    return favorite_service


def get_route_service():
    return route_service


def get_recommendation_service():
    return recommendation_service