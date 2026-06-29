import json

from app.schemas.tool_call import ToolCall


class ToolParser:

    @staticmethod
    def parse(text: str) -> ToolCall:
        try:
            data = json.loads(text)

            return ToolCall(
                tool=data.get("tool"),
                arguments=data.get("arguments", {}),
            )

        except Exception:
            return ToolCall()