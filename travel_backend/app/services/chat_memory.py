from collections import defaultdict

from app.schemas.companion import ChatMessage


class ChatMemory:

    def __init__(self):
        self._memory: dict[str, list[ChatMessage]] = defaultdict(list)

    def history(
        self,
        session_id: str,
    ) -> list[ChatMessage]:
        return self._memory[session_id]

    def add(
        self,
        session_id: str,
        role: str,
        content: str,
    ):

        self._memory[session_id].append(
            ChatMessage(
                role=role,
                content=content,
            )
        )

    def clear(
        self,
        session_id: str,
    ):
        self._memory.pop(session_id, None)


memory = ChatMemory()