from app.core.supabase import supabase


class VisitRepository:

    async def create_visit(self, place_id: str):
        existing = (
            supabase
            .table("visited_places")
            .select("id")
            .eq("user_id", "demo-user")
            .eq("place_id", place_id)
            .execute()
        )

        already_visited = len(existing.data) > 0

        if not already_visited:
            (
                supabase
                .table("visited_places")
                .insert({
                    "user_id": "demo-user",
                    "place_id": place_id,
                })
                .execute()
            )

        total = (
            supabase
            .table("visited_places")
            .select("id")
            .eq("user_id", "demo-user")
            .execute()
        )

        return {
            "already_visited": already_visited,
            "total_visits": len(total.data),
        }

    async def get_visits(self):
        return (
            supabase
            .table("visited_places")
            .select("""
                place_id,
                visited_at,
                places(
                    slug,
                    ai_score,
                    place_translations(
                        language,
                        name
                    )
                )
            """)
            .order("visited_at", desc=True)
            .execute()
        )