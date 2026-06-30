from fastapi import APIRouter

from app.services.recommendation_service import (
    recommendation_service,
)

router = APIRouter(
    prefix="/api/v1/recommendations",
    tags=["Recommendations"],
)


@router.get("/")
async def recommendations(
    lat: float,
    lng: float,
    radius: int = 3000,
    limit: int = 20,
):
    return await recommendation_service.nearby(
        lat,
        lng,
        radius,
        limit,
    )