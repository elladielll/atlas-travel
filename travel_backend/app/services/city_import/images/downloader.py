import httpx


class ImageDownloader:

    async def download(self, url: str) -> bytes | None:
        if not url:
            return None

        async with httpx.AsyncClient(timeout=120) as client:
            response = await client.get(url)

            if response.status_code != 200:
                return None

            return response.content