from fastapi import APIRouter

from app.repositories.place_repository import PlaceRepository

router = APIRouter(
    prefix="/api/v1/places",
    tags=["Places"],
)

repository = PlaceRepository()


@router.get("/")
async def get_places():
    return await repository.get_all_places()