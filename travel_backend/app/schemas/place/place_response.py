from pydantic import BaseModel


class PlaceTranslationResponse(BaseModel):
    name: dict[str, str]
    description: dict[str, str]
    aiSummary: dict[str, str]


class PlaceResponse(BaseModel):
    id: str

    slug: str

    category: str

    latitude: float

    longitude: float

    imageUrl: str | None

    website: str | None

    openingHours: str | None

    wikipedia: str | None

    wikidata: str | None

    aiScore: int

    estimatedDurationMinutes: int | None

    priceLevel: int | None

    bestTime: str | None

    cityId: str | None

    citySlug: str | None

    countryCode: str | None

    name: dict[str, str]

    description: dict[str, str]

    aiSummary: dict[str, str]