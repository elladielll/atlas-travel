from pydantic import BaseModel


class UserContext(BaseModel):
    city: str | None = None

    visited_places: list[str] = []

    favorite_places: list[str] = []

    interests: list[str] = []

    language: str = "English"