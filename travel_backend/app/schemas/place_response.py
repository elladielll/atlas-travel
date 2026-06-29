from pydantic import BaseModel


class LocalizedText(BaseModel):
    en: str
    uk: str


class PlaceResponse(BaseModel):
    id: str
    cityId: str
    countryCode: str

    category: str
    aiScore: float

    name: LocalizedText
    description: LocalizedText