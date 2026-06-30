from app.core.supabase import supabase


class TripRepository:

    async def create(
        self,
        user_id: str,
        city_id: str,
        title: str,
    ):

        response = (
            supabase
            .table("trips")
            .insert(
                {
                    "user_id": user_id,
                    "city_id": city_id,
                    "title": title,
                }
            )
            .execute()
        )

        return response.data[0]

    async def add_place(
        self,
        trip_id: str,
        place_id: str,
        order: int,
    ):

        (
            supabase
            .table("trip_places")
            .upsert(
                {
                    "trip_id": trip_id,
                    "place_id": place_id,
                    "visit_order": order,
                },
                on_conflict="trip_id,place_id",
            )
            .execute()
        )

    async def get(
        self,
        user_id: str,
    ):
        response = (
            supabase
            .table("trips")
            .select(
                """
                *,
                trip_places(
                    visit_order,
                    places(
                        id,
                        slug,
                        category,
                        latitude,
                        longitude,
                        image_url,
                        ai_score
                    )
                )
                """
            )
            .eq("user_id", user_id)
            .order("created_at", desc=True)
            .execute()
        )

        return response.data