from app.core.supabase import supabase


class FavoriteRepository:

    async def add(
        self,
        user_id: str,
        place_id: str,
    ):
        (
            supabase
            .table("user_favorites")
            .upsert(
                {
                    "user_id": user_id,
                    "place_id": place_id,
                },
                on_conflict="user_id,place_id",
            )
            .execute()
        )

    async def remove(
        self,
        user_id: str,
        place_id: str,
    ):
        (
            supabase
            .table("user_favorites")
            .delete()
            .eq("user_id", user_id)
            .eq("place_id", place_id)
            .execute()
        )

    async def get(
        self,
        user_id: str,
    ):
        response = (
            supabase
            .table("user_favorites")
            .select(
                """
                place_id,
                places(
                    id,
                    slug,
                    category,
                    latitude,
                    longitude,
                    image_url,
                    ai_score
                )
                """
            )
            .eq("user_id", user_id)
            .execute()
        )

        return response.data or []