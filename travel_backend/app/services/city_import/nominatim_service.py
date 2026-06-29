import httpx


class NominatimService:

    URL = "https://nominatim.openstreetmap.org/search"

    async def find_city(self, city: str) -> int:

        async with httpx.AsyncClient(timeout=60) as client:

            response = await client.get(
                self.URL,
                params={
                    "q": city,
                    "format": "jsonv2",
                    "limit": 1,
                    "polygon_geojson": 0,
                },
                headers={
                    "User-Agent": "Atlas Travel/1.0",
                },
            )

            response.raise_for_status()

            result = response.json()

        if not result:
            raise Exception(f"City '{city}' not found")

        osm_type = result[0]["osm_type"]
        osm_id = int(result[0]["osm_id"])

        if osm_type == "relation":
            return 3600000000 + osm_id

        if osm_type == "way":
            return 2400000000 + osm_id

        if osm_type == "node":
            return 3600000000 + osm_id

        raise Exception("Unsupported OSM type")