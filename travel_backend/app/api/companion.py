from fastapi import APIRouter

from app.repositories.companion_repository import CompanionRepository
from app.schemas.companion import ChatRequest, ClearChatRequest
from app.services.chat_memory import memory
from app.services.companion_service import CompanionService

router = APIRouter(
    prefix="/api/v1/companion",
    tags=["Companion"],
)

repository = CompanionRepository()
service = CompanionService()


@router.get("/")
async def get_companion():
    return await repository.get_dashboard()


@router.post("/chat")
async def chat(request: ChatRequest):
    return {
        "messages": await service.chat(
            message=request.message,
            session_id=request.session_id,
        ),
    }


@router.post("/chat/clear")
async def clear_chat(request: ClearChatRequest):
    memory.clear(request.session_id)

    return {
        "success": True,
        "message": "Chat cleared",
    }