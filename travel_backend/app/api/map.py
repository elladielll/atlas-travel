from fastapi import APIRouter

from app.repositories.map_repository import MapRepository

router = APIRouter(
    prefix="/api/v1/map",
    tags=["Map"],
)

repository = MapRepository()


@router.get("/places")
async def get_places():
    return await repository.get_places()