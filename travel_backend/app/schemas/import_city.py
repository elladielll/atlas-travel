from pydantic import BaseModel


class ImportCityRequest(BaseModel):
    city: str


class ImportCityResponse(BaseModel):
    success: bool
    imported: int
    failed: int
    total: int