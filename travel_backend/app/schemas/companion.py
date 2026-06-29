from pydantic import BaseModel


class ChatRequest(BaseModel):
    message: str
    session_id: str = "default"


class ClearChatRequest(BaseModel):
    session_id: str = "default"


class ChatMessage(BaseModel):
    role: str
    content: str


class ChatResponse(BaseModel):
    messages: list[ChatMessage]