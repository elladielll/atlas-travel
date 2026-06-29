from .models import ImportedPlace


class RankingService:
    MAX_PLACES = 300

    CATEGORY_SCORE = {
        "museum": 120,
        "castle": 120,
        "cathedral": 110,
        "church": 90,
        "monument": 100,
        "memorial": 80,
        "viewpoint": 100,
        "attraction": 100,
        "gallery": 90,
        "artwork": 70,
        "park": 60,
        "botanical_garden": 80,
        "zoo": 80,
        "aquarium": 80,
        "theme_park": 70,
        "beach": 70,
        "restaurant": 35,
        "cafe": 30,
        "bar": 20,
        "pub": 20,
    }

    @classmethod
    def rank(
        cls,
        places: list[ImportedPlace],
        limit: int | None = None,
    ) -> list[ImportedPlace]:
        scored = []

        for place in places:
            score = cls._score_place(place)

            if score <= 0:
                continue

            scored.append(
                (
                    score,
                    cls._place_name(place),
                    place,
                )
            )

        scored.sort(
            key=lambda item: (
                item[0],
                item[1],
            ),
            reverse=True,
        )

        max_places = limit or cls.MAX_PLACES

        return [
            item[2]
            for item in scored[:max_places]
        ]

    @classmethod
    def _score_place(
        cls,
        place: ImportedPlace,
    ) -> int:
        score = 0

        score += cls.CATEGORY_SCORE.get(
            place.category,
            0,
        )

        if place.wikidata:
            score += 80

        if place.wikipedia:
            score += 100

        if place.website:
            score += 20

        if place.opening_hours:
            score += 10

        name = cls._place_name(place).lower()

        if not name:
            return 0

        bad_keywords = [
            "parking",
            "toilet",
            "wc",
            "atm",
            "bank",
            "pharmacy",
            "gas",
            "fuel",
            "shop",
            "supermarket",
            "kiosk",
        ]

        if any(keyword in name for keyword in bad_keywords):
            score -= 100

        if len(name) < 3:
            score -= 50

        return score

    @staticmethod
    def _place_name(
        place: ImportedPlace,
    ) -> str:
        translation = (
            place.translations.get("en")
            or next(iter(place.translations.values()), {})
        )

        return translation.get("name", "").strip()