import json

import httpx

from app.core.config import settings
from app.schemas.ai_response import AIResponse
from app.services.ai_response_normalizer import normalize_ai_response


class BaseLLM:
    async def chat(self, prompt: str) -> AIResponse:
        raise NotImplementedError


class MockLLM(BaseLLM):
    async def chat(self, prompt: str) -> AIResponse:
        return AIResponse(
            message="Mock response from Atlas.",
            places=[],
            actions=[],
        )


class OpenRouterLLM(BaseLLM):
    async def chat(self, prompt: str) -> AIResponse:
        async with httpx.AsyncClient(timeout=60) as client:
            response = await client.post(
                "https://openrouter.ai/api/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {settings.OPENROUTER_API_KEY}",
                    "Content-Type": "application/json",
                },
                json={
                    "model": settings.OPENROUTER_MODEL,
                    "messages": [
                        {
                            "role": "system",
                            "content": """
You are Atlas, a premium AI travel companion.

Return ONLY valid JSON.

Preferred schema:

{
  "message": "string",
  "places": [
    {
      "id": "string",
      "title": "string"
    }
  ],
  "actions": [
    {
      "type": "string",
      "value": "string"
    }
  ]
}

If you are not sure about places or actions, return empty arrays.
""",
                        },
                        {
                            "role": "user",
                            "content": prompt,
                        },
                    ],
                    "temperature": 0.7,
                    "max_tokens": 1000,
                },
            )

            response.raise_for_status()

            content = response.json()["choices"][0]["message"]["content"]

            try:
                raw = json.loads(content)
            except json.JSONDecodeError:
                raw = {
                    "message": content,
                    "places": [],
                    "actions": [],
                }

            return normalize_ai_response(raw)


llm: BaseLLM = (
    OpenRouterLLM()
    if settings.OPENROUTER_API_KEY
    else MockLLM()
)