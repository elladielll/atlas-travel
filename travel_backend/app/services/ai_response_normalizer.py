import json
from typing import Any

from app.schemas.ai_response import AIAction, AIPlace, AIResponse


def normalize_ai_response(raw: Any) -> AIResponse:
    if isinstance(raw, str):
        try:
            raw = json.loads(raw)
        except json.JSONDecodeError:
            return AIResponse(
                message=raw,
                places=[],
                actions=[],
            )

    if not isinstance(raw, dict):
        return AIResponse(
            message=str(raw),
            places=[],
            actions=[],
        )

    message = (
        raw.get("message")
        or raw.get("answer")
        or raw.get("response")
        or raw.get("content")
        or ""
    )

    places = _normalize_places(raw.get("places", []))
    actions = _normalize_actions(raw.get("actions", []))

    return AIResponse(
        message=str(message),
        places=places,
        actions=actions,
    )


def _normalize_places(raw_places: Any) -> list[AIPlace]:
    if not isinstance(raw_places, list):
        return []

    places: list[AIPlace] = []

    for index, item in enumerate(raw_places):
        if isinstance(item, str):
            places.append(
                AIPlace(
                    id=f"generated-{index}",
                    title=item,
                )
            )
            continue

        if not isinstance(item, dict):
            continue

        place_id = (
            item.get("id")
            or item.get("place_id")
            or item.get("slug")
            or f"generated-{index}"
        )

        title = (
            item.get("title")
            or item.get("name")
            or item.get("label")
            or item.get("place")
            or "Unknown place"
        )

        places.append(
            AIPlace(
                id=str(place_id),
                title=str(title),
            )
        )

    return places


def _normalize_actions(raw_actions: Any) -> list[AIAction]:
    if not isinstance(raw_actions, list):
        return []

    actions: list[AIAction] = []

    for index, item in enumerate(raw_actions):
        if isinstance(item, str):
            actions.append(
                AIAction(
                    type="suggestion",
                    value=item,
                )
            )
            continue

        if not isinstance(item, dict):
            continue

        action_type = (
            item.get("type")
            or item.get("action_type")
            or item.get("action")
            or "suggestion"
        )

        value = (
            item.get("value")
            or item.get("label")
            or item.get("title")
            or item.get("text")
            or item.get("description")
            or ""
        )

        actions.append(
            AIAction(
                type=str(action_type),
                value=str(value),
            )
        )

    return actions