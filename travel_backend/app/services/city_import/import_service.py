from app.services.city_import.importer import import_city


class ImportService:

    async def import_city(
        self,
        city: str,
    ) -> int:

        places = await import_city(city)

        # Пока только возвращаем количество.
        # Следующим пакетом сохраним их в Supabase.

        return len(places)


import_service = ImportService()