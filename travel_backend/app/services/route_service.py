from math import radians, sin, cos, sqrt, atan2

from app.repositories.place_repository import PlaceRepository


class RouteService:

    def __init__(self):
        self.repository = PlaceRepository()

    def distance(self, a, b):

        R = 6371000

        lat1 = radians(a["latitude"])
        lon1 = radians(a["longitude"])

        lat2 = radians(b["latitude"])
        lon2 = radians(b["longitude"])

        dlat = lat2 - lat1
        dlon = lon2 - lon1

        x = (
            sin(dlat / 2) ** 2
            + cos(lat1)
            * cos(lat2)
            * sin(dlon / 2) ** 2
        )

        return 2 * R * atan2(
            sqrt(x),
            sqrt(1 - x),
        )

    async def build(
        self,
        city_id: str,
        hours: int,
        categories: list[str] | None = None,
    ):

        places = await self.repository.get_all_places(
            limit=500,
            city_id=city_id,
            categories=categories,
        )

        if not places:
            return []

        places.sort(
            key=lambda p: p["aiScore"],
            reverse=True,
        )

        route = []

        current = places.pop(0)

        route.append(current)

        minutes = current.get(
            "estimatedDurationMinutes"
        ) or 60

        while places:

            if minutes >= hours * 60:
                break

            nearest = min(
                places,
                key=lambda x: self.distance(
                    current,
                    x,
                ),
            )

            places.remove(nearest)

            route.append(nearest)

            current = nearest

            minutes += (
                nearest.get(
                    "estimatedDurationMinutes"
                )
                or 60
            )

        return route


route_service = RouteService()