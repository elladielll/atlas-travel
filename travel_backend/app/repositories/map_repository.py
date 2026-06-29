from app.core.supabase import supabase


class MapRepository:

    async def get_places(self):
        response = (
            supabase
            .table("places")
            .select("""
                id,
                latitude,
                longitude,
                ai_score,
                category,
                place_translations(
                    language,
                    name
                )
            """)
            .execute()
        )

        return response.data