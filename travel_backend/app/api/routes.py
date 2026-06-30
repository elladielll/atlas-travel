from typing import Annotated

from fastapi import APIRouter, Query

from app.services.route_service import route_service

router = APIRouter(
    prefix="/api/v1/routes",
    tags=["Routes"],
)


@router.get("/generate")
async def generate_route(

    city_id: str,

    hours: int = 6,

    categories: Annotated[
        list[str] | None,
        Query()
    ] = None,

):

    return await route_service.build(
        city_id,
        hours,
        categories,
    )