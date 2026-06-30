from app.repositories.favorite_repository import FavoriteRepository


class FavoriteService:

    def __init__(self):
        self.repository = FavoriteRepository()

    async def add(
        self,
        user_id: str,
        place_id: str,
    ):
        await self.repository.add(
            user_id,
            place_id,
        )

    async def remove(
        self,
        user_id: str,
        place_id: str,
    ):
        await self.repository.remove(
            user_id,
            place_id,
        )

    async def get(
        self,
        user_id: str,
    ):
        return await self.repository.get(
            user_id,
        )


favorite_service = FavoriteService()