import httpx


class WikidataService:

    async def load(self, entity: str) -> dict | None:

        if not entity:
            return None

        url = f"https://www.wikidata.org/wiki/Special:EntityData/{entity}.json"

        async with httpx.AsyncClient(timeout=60) as client:

            response = await client.get(url)

            if response.status_code != 200:
                return None

            return response.json()