import json

from app.schemas.companion import ChatMessage

from app.services.chat_memory import memory
from app.services.context_service import ContextService
from app.services.llm_service import llm
from app.services.prompt_builder import PromptBuilder
from app.services.tool_parser import ToolParser
from app.services.tool_service import ToolService


class CompanionService:

    def __init__(self):
        self.context = ContextService()
        self.tools = ToolService()

    async def chat(
        self,
        message: str,
        session_id: str,
    ) -> list[ChatMessage]:

        context = await self.context.build()

        history = memory.history(session_id)

        prompt = PromptBuilder.build(
            context=context,
            history=history,
            message=message,
        )

        first = await llm.chat(prompt)

        tool = ToolParser.parse(first.message)

        if tool.tool:

            result = await self.tools.execute(
                tool.tool,
                tool.arguments,
            )

            second_prompt = f"""
The requested tool has returned:

{json.dumps(result, ensure_ascii=False)}

Answer the user naturally.

User:

{message}
"""

            final = await llm.chat(second_prompt)

            answer = final.message

        else:
            answer = first.message

        memory.add(
            session_id,
            "user",
            message,
        )

        memory.add(
            session_id,
            "assistant",
            answer,
        )

        return [
            ChatMessage(
                role="user",
                content=message,
            ),
            ChatMessage(
                role="assistant",
                content=answer,
            ),
        ]