from app.core.supabase import supabase


class PlaceRepository:

    async def get_all_places(self):
        response = (
            supabase
            .table("places")
            .select(
                """
                id,
                slug,
                category,
                ai_score,
                cities (
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
            .execute()
        )

        places = []

        for item in response.data:
            translations = item.get("place_translations", [])

            name = {}
            description = {}

            for translation in translations:
                language = translation["language"]

                name[language] = translation["name"]
                description[language] = (
                    translation.get("description") or ""
                )

            city = item.get("cities") or {}
            country = city.get("countries") or {}

            places.append(
                {
                    "id": item["id"],
                    "slug": item["slug"],
                    "cityId": city.get("slug", ""),
                    "countryCode": country.get("code", ""),
                    "category": item["category"],
                    "aiScore": item["ai_score"],
                    "name": name,
                    "description": description,
                }
            )

        return places

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
                ai_score,
                cities (
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

        places = []

        for item in response.data:
            translations = item.get("place_translations", [])

            name = {}
            description = {}

            for translation in translations:
                language = translation["language"]

                name[language] = translation["name"]
                description[language] = (
                    translation.get("description") or ""
                )

            city = item.get("cities") or {}
            country = city.get("countries") or {}

            places.append(
                {
                    "id": item["id"],
                    "slug": item["slug"],
                    "cityId": city.get("slug", ""),
                    "countryCode": country.get("code", ""),
                    "category": item["category"],
                    "aiScore": item["ai_score"],
                    "name": name,
                    "description": description,
                }
            )

        return places