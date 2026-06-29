from pydantic import BaseModel


class ToolCall(BaseModel):
    tool: str | None = None
    arguments: dict = {}