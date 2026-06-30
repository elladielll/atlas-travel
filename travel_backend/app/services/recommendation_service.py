from math import radians, sin, cos, sqrt, atan2

from app.repositories.place_repository import PlaceRepository


class RecommendationService:

    def __init__(self):
        self.repository = PlaceRepository()

    def _distance(
        self,
        lat1,
        lon1,
        lat2,
        lon2,
    ):
        R = 6371000

        dlat = radians(lat2 - lat1)
        dlon = radians(lon2 - lon1)

        a = (
            sin(dlat / 2) ** 2
            + cos(radians(lat1))
            * cos(radians(lat2))
            * sin(dlon / 2) ** 2
        )

        return R * 2 * atan2(
            sqrt(a),
            sqrt(1 - a),
        )

    async def nearby(
        self,
        lat: float,
        lng: float,
        radius: int = 3000,
        limit: int = 20,
    ):

        places = await self.repository.get_all_places()

        result = []

        for place in places:

            distance = self._distance(
                lat,
                lng,
                place["latitude"],
                place["longitude"],
            )

            if distance > radius:
                continue

            score = (
                place["aiScore"]
                - distance / 100
            )

            place["distance"] = round(distance)
            place["score"] = round(score, 2)

            result.append(place)

        result.sort(
            key=lambda x: x["score"],
            reverse=True,
        )

        return result[:limit]


recommendation_service = RecommendationService()