from app.core.supabase import supabase


class ImportRepository:

    async def upsert_country(
        self,
        code: str,
        name: str,
    ) -> str:

        response = (
            supabase
            .table("countries")
            .upsert(
                {
                    "code": code,
                    "name": {
                        "en": name,
                    },
                    "flag_emoji": "",
                },
                on_conflict="code",
            )
            .execute()
        )

        country = (
            supabase
            .table("countries")
            .select("id")
            .eq("code", code)
            .single()
            .execute()
        )

        return country.data["id"]

    async def upsert_city(
        self,
        city,
    ) -> str:

        country_id = await self.upsert_country(
            city.country,
            city.country_name if hasattr(city, "country_name") else city.country,
        )

        (
            supabase
            .table("cities")
            .upsert(
                {
                    "country_id": country_id,
                    "slug": city.name.lower(),
                    "name": {
                        "en": city.name,
                    },
                    "latitude": city.latitude,
                    "longitude": city.longitude,
                    "timezone": getattr(city, "timezone", "UTC"),
                },
                on_conflict="slug",
            )
            .execute()
        )

        result = (
            supabase
            .table("cities")
            .select("id")
            .eq("slug", city.name.lower())
            .single()
            .execute()
        )

        return result.data["id"]

    async def bulk_upsert_places(
        self,
        city_id: str,
        places: list,
    ) -> dict[str, str]:

        payload = []

        for place in places:

            payload.append(
                {
                    "osm_id": int(place.osm_id),
                    "city_id": city_id,
                    "slug": place.slug,
                    "category": place.category,
                    "latitude": place.latitude,
                    "longitude": place.longitude,
                    "website": place.website,
                    "opening_hours": place.opening_hours,
                    "wikipedia": place.wikipedia,
                    "wikidata": place.wikidata,
                    "image_url": place.image_url,
                    "ai_score": 0,
                    "estimated_duration_minutes": None,
                    "price_level": None,
                    "best_time": None,
                }
            )

        (
            supabase
            .table("places")
            .upsert(
                payload,
                on_conflict="osm_id",
            )
            .execute()
        )

        osm_ids = [
            int(place.osm_id)
            for place in places
        ]

        result = (
            supabase
            .table("places")
            .select(
                "id, osm_id",
            )
            .in_(
                "osm_id",
                osm_ids,
            )
            .execute()
        )

        return {
            str(row["osm_id"]): row["id"]
            for row in result.data
        }

    async def bulk_upsert_translations(
        self,
        places: list,
        place_ids: dict[str, str],
    ):

        payload = []

        for place in places:

            place_id = place_ids.get(
                str(place.osm_id)
            )

            if not place_id:
                continue

            for language, translation in place.translations.items():

                payload.append(
                    {
                        "place_id": place_id,
                        "language": language,
                        "name": translation.get(
                            "name",
                            "",
                        ),
                        "description": translation.get(
                            "description",
                            "",
                        ),
                        "ai_summary": translation.get(
                            "ai_summary",
                            "",
                        ),
                    }
                )

        (
            supabase
            .table("place_translations")
            .upsert(
                payload,
                on_conflict="place_id,language",
            )
            .execute()
        )