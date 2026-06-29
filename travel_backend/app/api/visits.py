from fastapi import APIRouter

from app.repositories.visit_repository import VisitRepository

router = APIRouter(
    prefix="/api/v1/visits",
    tags=["Visits"],
)

repository = VisitRepository()


@router.post("/")
async def create_visit(payload: dict):
    place_id = payload.get("place_id")

    result = await repository.create_visit(place_id)

    return {
        "success": True,
        "message": "Visit saved",
        "place_id": place_id,
        "already_visited": result["already_visited"],
        "total_visits": result["total_visits"],
    }


@router.get("/")
async def get_visits():
    response = await repository.get_visits()
    return response.data