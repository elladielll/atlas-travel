import httpx


class WikipediaService:

    async def summary(
        self,
        title: str,
    ) -> dict | None:

        url = (
            "https://en.wikipedia.org/api/rest_v1/page/summary/"
            + title
        )

        async with httpx.AsyncClient(timeout=60) as client:

            response = await client.get(url)

            if response.status_code != 200:
                return None

            return response.json()