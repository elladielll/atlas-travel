from fastapi import APIRouter, HTTPException

from app.services.place_service import place_service

from typing import Annotated

from fastapi import Query

router = APIRouter(
    prefix="/api/v1/places",
    tags=["Places"],
)


@router.get("/")
async def get_places(

    limit: int = 50,
    offset: int = 0,

    city_id: str | None = None,

    categories: Annotated[
        list[str] | None,
        Query()
    ] = None,

    min_score: int | None = None,

):
    return await place_service.get_all_places(
        limit,
        offset,
        city_id,
        categories,
        min_score,
    )


@router.get("/cities")
async def get_cities():
    return await place_service.get_cities()


@router.get("/cities/{city_id}/places")
async def get_places_by_city(
    city_id: str,
):
    return await place_service.get_places_by_city(city_id)

@router.get("/search")
async def search_places(
    q: str,
):
    return await place_service.search(q)

@router.get("/category/{category}")
async def by_category(
    category: str,
    city_id: str | None = None,
):
    return await place_service.get_by_category(
        category,
        city_id,
    )

@router.get("/{place_id}")
async def get_place(
    place_id: str,
):
    place = await place_service.get_place_by_id(place_id)

    if not place:
        raise HTTPException(
            status_code=404,
            detail="Place not found",
        )

    return place