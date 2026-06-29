from fastapi import APIRouter

from app.schemas.import_city import (
    ImportCityRequest,
    ImportCityResponse,
)
from app.services.city_import.import_service import import_service

router = APIRouter(
    prefix="/api/v1/import",
    tags=["Import"],
)


@router.post(
    "/city",
    response_model=ImportCityResponse,
)
async def import_city(
    request: ImportCityRequest,
):

    count = await import_service.import_city(
        request.city,
    )

    return ImportCityResponse(
        success=True,
        imported=count,
    )