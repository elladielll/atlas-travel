from app.schemas.context import UserContext


class ContextService:

    async def build(self) -> UserContext:
        """
        Пока возвращаем статический контекст.

        Позже здесь будут:
        - Passport
        - Favorites
        - Visits
        - Current location
        - Weather
        """

        return UserContext(
            city="Dnipro",
            visited_places=[
                "Monastyr Island",
                "Menorah Center",
            ],
            favorite_places=[
                "Rocket Park",
            ],
            interests=[
                "architecture",
                "coffee",
                "walking",
            ],
            language="English",
        )