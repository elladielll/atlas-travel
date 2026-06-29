import asyncio

import httpx


class OverpassClient:

    SERVERS = [
        "https://overpass-api.de/api/interpreter",
        "https://overpass.kumi.systems/api/interpreter",
        "https://lz4.overpass-api.de/api/interpreter",
    ]

    async def query(self, query: str) -> dict:

        headers = {
            "User-Agent": "Atlas Travel/1.0",
            "Accept": "application/json",
        }

        last_error = None

        for server in self.SERVERS:

            try:
                async with httpx.AsyncClient(timeout=120) as client:

                    response = await client.post(
                        server,
                        headers=headers,
                        data={
                            "data": query,
                        },
                    )

                    response.raise_for_status()

                    return response.json()

            except Exception as e:
                print(f"Overpass failed: {server}")
                print(e)

                last_error = e

                await asyncio.sleep(1)

        raise last_error