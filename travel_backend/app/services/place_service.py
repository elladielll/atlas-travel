from app.repositories.place_repository import PlaceRepository


class PlaceService:

    def __init__(self):
        self.repository = PlaceRepository()

    async def get_cities(self):
        return await self.repository.get_cities()

    async def get_all_places(
        self,
        limit: int = 50,
        offset: int = 0,
        city_id: str | None = None,
        categories: list[str] | None = None,
        min_score: int | None = None,
    ):
        return await self.repository.get_all_places(
            limit,
            offset,
            city_id,
            categories,
            min_score,
        )

    async def get_places_by_city(
        self,
        city_id: str,
    ):
        return await self.repository.get_places_by_city(
            city_id,
        )

    async def get_place_by_id(
        self,
        place_id: str,
    ):
        return await self.repository.get_place_by_id(
            place_id,
        )

    async def search(
        self,
        query: str,
    ):
        return await self.repository.search(
            query,
        )
    
    async def get_by_category(
        self,
        category: str,
        city_id: str | None = None,
    ):
        return await self.repository.get_by_category(
            category,
            city_id,
        )


place_service = PlaceService()