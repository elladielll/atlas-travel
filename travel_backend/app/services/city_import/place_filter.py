from .models import ImportedPlace


class PlaceFilter:

    ALLOWED_CATEGORIES = {
    "museum",
    "gallery",
    "attraction",
    "viewpoint",
    "theme_park",
    "zoo",
    "aquarium",
    "park",
    "botanical_garden",
    "castle",
    "church",
    "cathedral",
    "memorial",
    "monument",
    "artwork",
    "beach",
    "restaurant",
    "cafe",
    "bar",
    "pub",
}

    CATEGORY_MAPPING = {
    "coffee_shop": "cafe",
    "fast_food": "restaurant",
    "biergarten": "bar",

    "fountain": "attraction",

    "theatre": "attraction",

    "cinema": "attraction",

    "arts_centre": "gallery",

    "library": "attraction",

    "memorial": "monument",

    "monument": "monument",

    "castle": "castle",

    "viewpoint": "viewpoint",

    "artwork": "artwork",
}

    @classmethod
    def filter(
        cls,
        places: list[ImportedPlace],
    ) -> list[ImportedPlace]:

        unique = {}

        for place in places:

            category = cls.CATEGORY_MAPPING.get(
                place.category,
                place.category,
            )

            if category not in cls.ALLOWED_CATEGORIES:
                continue

            place.category = category

            key = (
                place.name.lower().strip(),
                round(place.latitude, 5),
                round(place.longitude, 5),
            )

            unique[key] = place

        return sorted(
            unique.values(),
            key=lambda p: (
                p.category,
                p.name,
            ),
        )