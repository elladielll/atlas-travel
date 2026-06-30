from fastapi import APIRouter

from app.services.trip_service import trip_service

router = APIRouter(
    prefix="/api/v1/trips",
    tags=["Trips"],
)


@router.get("/")
async def trips(
    user_id: str,
):
    return await trip_service.get(
        user_id,
    )


@router.post("/")
async def create_trip(
    user_id: str,
    city_id: str,
    title: str,
):
    return await trip_service.create(
        user_id,
        city_id,
        title,
    )


@router.post("/{trip_id}/places/{place_id}")
async def add_place(
    trip_id: str,
    place_id: str,
    order: int,
):
    await trip_service.add_place(
        trip_id,
        place_id,
        order,
    )

    return {
        "success": True,
    }