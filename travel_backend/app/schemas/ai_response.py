from pydantic import BaseModel, Field


class AIPlace(BaseModel):
    id: str
    title: str


class AIAction(BaseModel):
    type: str
    value: str


class AIResponse(BaseModel):
    message: str

    places: list[AIPlace] = Field(default_factory=list)

    actions: list[AIAction] = Field(default_factory=list)