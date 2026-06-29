import httpx


class NominatimService:

    URL = "https://nominatim.openstreetmap.org/search"

    async def find_city(
        self,
        city: str,
    ) -> dict:

        async with httpx.AsyncClient(timeout=60) as client:

            response = await client.get(
                self.URL,
                params={
                    "q": city,
                    "format": "jsonv2",
                    "addressdetails": 1,
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

        item = result[0]

        osm_type = item["osm_type"]
        osm_id = int(item["osm_id"])

        if osm_type == "relation":
            area_id = 3600000000 + osm_id
        elif osm_type == "way":
            area_id = 2400000000 + osm_id
        elif osm_type == "node":
            area_id = 3600000000 + osm_id
        else:
            raise Exception("Unsupported OSM type")

        address = item.get("address", {})

        return {
            "area_id": area_id,
            "city": (
                address.get("city")
                or address.get("town")
                or address.get("village")
                or city
            ),
            "country": address.get("country", ""),
            "country_code": (
                address.get("country_code", "").upper()
            ),
            "latitude": float(item["lat"]),
            "longitude": float(item["lon"]),
            "display_name": item.get("display_name", ""),
        }