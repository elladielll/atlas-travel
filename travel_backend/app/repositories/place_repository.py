from app.core.supabase import supabase


class PlaceRepository:

    def _map_place(self, item):
        translations = item.get("place_translations", [])

        name = {}
        description = {}
        ai_summary = {}

        for translation in translations:
            language = translation.get("language", "en")

            name[language] = translation.get("name") or ""
            description[language] = translation.get("description") or ""
            ai_summary[language] = translation.get("ai_summary") or ""

        city = item.get("cities") or {}
        country = city.get("countries") or {}

        return {
            "id": item["id"],
            "slug": item.get("slug"),
            "cityId": city.get("id"),
            "citySlug": city.get("slug"),
            "countryCode": country.get("code", ""),
            "category": item.get("category"),
            "latitude": item.get("latitude"),
            "longitude": item.get("longitude"),
            "imageUrl": item.get("image_url"),
            "website": item.get("website"),
            "openingHours": item.get("opening_hours"),
            "wikipedia": item.get("wikipedia"),
            "wikidata": item.get("wikidata"),
            "aiScore": item.get("ai_score") or 0,
            "estimatedDurationMinutes": item.get("estimated_duration_minutes"),
            "priceLevel": item.get("price_level"),
            "bestTime": item.get("best_time"),
            "name": name,
            "description": description,
            "aiSummary": ai_summary,
        }

    async def get_cities(self):
        response = (
            supabase
            .table("cities")
            .select(
                """
                id,
                slug,
                name,
                latitude,
                longitude,
                timezone,
                countries (
                    code,
                    name,
                    flag_emoji
                )
                """
            )
            .order("slug")
            .execute()
        )

        return response.data or []

    async def get_all_places(
        self,
        limit: int = 50,
        offset: int = 0,
        city_id: str | None = None,
        categories: list[str] | None = None,
        min_score: int | None = None,
    ):

        query = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                latitude,
                longitude,
                image_url,
                website,
                opening_hours,
                wikipedia,
                wikidata,
                ai_score,
                estimated_duration_minutes,
                price_level,
                best_time,
                cities(
                    id,
                    slug,
                    countries(
                        code
                    )
                ),
                place_translations(
                    language,
                    name,
                    description,
                    ai_summary
                )
                """
            )
        )

        if city_id:
            query = query.eq(
                "city_id",
                city_id,
            )

        if categories:
            query = query.in_(
                "category",
                categories,
            )

        if min_score is not None:
            query = query.gte(
                "ai_score",
                min_score,
            )

        response = (
            query
            .order("ai_score", desc=True)
            .range(offset, offset + limit - 1)
            .execute()
        )

        return [
            self._map_place(item)
            for item in response.data or []
        ]

    async def get_places_by_city(
        self,
        city_id: str,
    ):
        response = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                latitude,
                longitude,
                image_url,
                website,
                opening_hours,
                wikipedia,
                wikidata,
                ai_score,
                estimated_duration_minutes,
                price_level,
                best_time,
                cities (
                    id,
                    slug,
                    countries (
                        code
                    )
                ),
                place_translations (
                    language,
                    name,
                    description,
                    ai_summary
                )
                """
            )
            .eq("city_id", city_id)
            .order("ai_score", desc=True)
            .execute()
        )

        return [
            self._map_place(item)
            for item in response.data or []
        ]

    async def get_place_by_id(
        self,
        place_id: str,
    ):
        response = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                latitude,
                longitude,
                image_url,
                website,
                opening_hours,
                wikipedia,
                wikidata,
                ai_score,
                estimated_duration_minutes,
                price_level,
                best_time,
                cities (
                    id,
                    slug,
                    countries (
                        code
                    )
                ),
                place_translations (
                    language,
                    name,
                    description,
                    ai_summary
                )
                """
            )
            .eq("id", place_id)
            .single()
            .execute()
        )

        if not response.data:
            return None

        return self._map_place(response.data)

    async def find_by_category(
        self,
        category: str,
    ):
        response = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                latitude,
                longitude,
                image_url,
                website,
                opening_hours,
                wikipedia,
                wikidata,
                ai_score,
                estimated_duration_minutes,
                price_level,
                best_time,
                cities (
                    id,
                    slug,
                    countries (
                        code
                    )
                ),
                place_translations (
                    language,
                    name,
                    description,
                    ai_summary
                )
                """
            )
            .ilike("category", f"%{category}%")
            .limit(20)
            .execute()
        )

        return [
            self._map_place(item)
            for item in response.data or []
        ]

    async def search(
        self,
        query: str,
        limit: int = 20,
    ):

        response = (
            supabase
            .table("place_translations")
            .select(
                """
                language,
                name,
                description,
                ai_summary,
                places(
                    id,
                    slug,
                    category,
                    latitude,
                    longitude,
                    image_url,
                    website,
                    opening_hours,
                    wikipedia,
                    wikidata,
                    ai_score,
                    estimated_duration_minutes,
                    price_level,
                    best_time,
                    cities(
                        id,
                        slug,
                        countries(
                            code
                        )
                    )
                )
                """
            )
            .ilike("name", f"%{query}%")
            .limit(limit)
            .execute()
        )

        places = []

        for row in response.data or []:

            place = row["places"]

            place["place_translations"] = [
                {
                    "language": row["language"],
                    "name": row["name"],
                    "description": row["description"],
                    "ai_summary": row["ai_summary"],
                }
            ]

            places.append(
                self._map_place(place)
            )

        return places

    async def get_by_category(
        self,
        category: str,
        city_id: str | None = None,
    ):

        query = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                latitude,
                longitude,
                image_url,
                website,
                opening_hours,
                wikipedia,
                wikidata,
                ai_score,
                estimated_duration_minutes,
                price_level,
                best_time,
                cities(
                    id,
                    slug,
                    countries(
                        code
                    )
                ),
                place_translations(
                    language,
                    name,
                    description,
                    ai_summary
                )
                """
            )
            .eq("category", category)
            .order("ai_score", desc=True)
        )

        if city_id:
            query = query.eq(
                "city_id",
                city_id,
            )

        response = query.execute()

        return [
            self._map_place(item)
            for item in response.data or []
        ]