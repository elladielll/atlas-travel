from fastapi import APIRouter

from app.services.favorite_service import favorite_service

router = APIRouter(
    prefix="/api/v1/favorites",
    tags=["Favorites"],
)


@router.get("/")
async def get_favorites(
    user_id: str,
):
    return await favorite_service.get(
        user_id,
    )


@router.post("/{place_id}")
async def add_favorite(
    place_id: str,
    user_id: str,
):
    await favorite_service.add(
        user_id,
        place_id,
    )

    return {
        "success": True,
    }


@router.delete("/{place_id}")
async def remove_favorite(
    place_id: str,
    user_id: str,
):
    await favorite_service.remove(
        user_id,
        place_id,
    )

    return {
        "success": True,
    }