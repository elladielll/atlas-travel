from app.repositories.trip_repository import TripRepository


class TripService:

    def __init__(self):
        self.repository = TripRepository()

    async def create(
        self,
        user_id,
        city_id,
        title,
    ):
        return await self.repository.create(
            user_id,
            city_id,
            title,
        )

    async def add_place(
        self,
        trip_id,
        place_id,
        order,
    ):
        await self.repository.add_place(
            trip_id,
            place_id,
            order,
        )

    async def get(
        self,
        user_id,
    ):
        return await self.repository.get(
            user_id,
        )


trip_service = TripService()