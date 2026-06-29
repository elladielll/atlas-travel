from app.core.supabase import supabase


class ImportRepository:

    async def upsert_city(
        self,
        city,
    ):

        response = (
            supabase
            .table("cities")
            .upsert(
                {
                    "slug": city.name.lower(),

                    "country_code": city.country,
                }
            )
            .execute()
        )

        return response.data[0]["id"]

    async def upsert_place(
        self,
        city_id,
        place,
    ):

        response = (
            supabase
            .table("places")
            .upsert(
                {
                    "slug": place.slug,

                    "city_id": city_id,

                    "category": place.category,

                    "latitude": place.latitude,

                    "longitude": place.longitude,

                    "website": place.website,

                    "opening_hours": place.opening_hours,

                    "osm_id": place.osm_id,

                    "wikidata": place.wikidata,

                    "wikipedia": place.wikipedia,

                    "image_url": place.image_url,
                }
            )
            .execute()
        )

        place_id = response.data[0]["id"]

        for language, translation in place.translations.items():

            (
                supabase
                .table("place_translations")
                .upsert(
                    {
                        "place_id": place_id,

                        "language": language,

                        "name": translation["name"],

                        "description": translation["description"],

                        "ai_summary": translation["ai_summary"],
                    }
                )
                .execute()
            )

        return place_id