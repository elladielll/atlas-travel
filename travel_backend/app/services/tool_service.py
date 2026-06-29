from app.repositories.place_repository import PlaceRepository


class ToolService:

    def __init__(self):
        self.repository = PlaceRepository()

    async def execute(
        self,
        tool: str,
        arguments: dict,
    ):

        if tool != "find_places":
            return None

        category = arguments.get("category")

        if not category:
            return None

        places = await self.repository.find_by_category(category)

        return {
            "places": places
        }