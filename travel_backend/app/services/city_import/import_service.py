from app.services.city_import.import_repository import ImportRepository
from app.services.city_import.importer import import_city
from app.services.city_import.ranking_service import RankingService


class ImportService:

    def __init__(self):
        self.repository = ImportRepository()

    async def import_city(
        self,
        city: str,
    ) -> dict:

        print(f"\n🌍 Importing city: {city}")

        places = await import_city(city)

        print(f"📦 Loaded from Overpass: {len(places)}")

        if not places:
            return {
                "success": False,
                "imported": 0,
                "failed": 0,
                "total": 0,
                "message": "No places found",
            }

        ranked_places = RankingService.rank(places)

        print(f"⭐ Selected {len(ranked_places)} places")

        city_id = await self.repository.upsert_city(
            ranked_places[0].city,
        )

        print("⬆ Saving places...")

        place_ids = await self.repository.bulk_upsert_places(
            city_id,
            ranked_places,
        )

        print("🌍 Saving translations...")

        await self.repository.bulk_upsert_translations(
            ranked_places,
            place_ids,
        )

        imported = len(place_ids)
        failed = len(ranked_places) - imported

        print("\n==============================")
        print(f"Imported : {imported}")
        print(f"Failed   : {failed}")
        print("==============================\n")

        return {
            "success": True,
            "imported": imported,
            "failed": failed,
            "total": len(ranked_places),
        }


import_service = ImportService()