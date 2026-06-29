from .models import ImportedCity
from .models import ImportedPlace
from .nominatim_service import NominatimService
from .overpass_client import OverpassClient
from .place_filter import PlaceFilter
from .slug import slugify


class OverpassService:

    def __init__(self):
        self.client = OverpassClient()
        self.nominatim = NominatimService()

    async def load_city(
        self,
        city: str,
    ) -> list[ImportedPlace]:

        area = await self.nominatim.find_city(city)

        query = f"""
[out:json][timeout:180];

area({area})->.searchArea;

(
    node(area.searchArea)["tourism"];
    way(area.searchArea)["tourism"];
    relation(area.searchArea)["tourism"];

    node(area.searchArea)["historic"];
    way(area.searchArea)["historic"];
    relation(area.searchArea)["historic"];

    node(area.searchArea)["museum"];
    way(area.searchArea)["museum"];

    node(area.searchArea)["leisure"];
    way(area.searchArea)["leisure"];

    node(area.searchArea)["natural"];
    way(area.searchArea)["natural"];

    node(area.searchArea)["amenity"="restaurant"];
    way(area.searchArea)["amenity"="restaurant"];

    node(area.searchArea)["amenity"="cafe"];
    way(area.searchArea)["amenity"="cafe"];

    node(area.searchArea)["amenity"="bar"];
    way(area.searchArea)["amenity"="bar"];

    node(area.searchArea)["amenity"="pub"];
    way(area.searchArea)["amenity"="pub"];

    node(area.searchArea)["amenity"="fast_food"];
    way(area.searchArea)["amenity"="fast_food"];

    node(area.searchArea)["amenity"="arts_centre"];
    way(area.searchArea)["amenity"="arts_centre"];

    node(area.searchArea)["amenity"="theatre"];
    way(area.searchArea)["amenity"="theatre"];

    node(area.searchArea)["amenity"="cinema"];
    way(area.searchArea)["amenity"="cinema"];

    node(area.searchArea)["amenity"="library"];
    way(area.searchArea)["amenity"="library"];

    node(area.searchArea)["amenity"="fountain"];
    way(area.searchArea)["amenity"="fountain"];

    node(area.searchArea)["bridge"];
    way(area.searchArea)["bridge"];

    node(area.searchArea)["tourism"="viewpoint"];
    way(area.searchArea)["tourism"="viewpoint"];

    node(area.searchArea)["historic"="memorial"];
    way(area.searchArea)["historic"="memorial"];

    node(area.searchArea)["historic"="monument"];
    way(area.searchArea)["historic"="monument"];

    node(area.searchArea)["historic"="castle"];
    way(area.searchArea)["historic"="castle"];

    node(area.searchArea)["tourism"="artwork"];
    way(area.searchArea)["tourism"="artwork"];
);

out center tags;
"""

        data = await self.client.query(query)

        places: list[ImportedPlace] = []

        for element in data.get("elements", []):

            tags = element.get("tags", {})

            if "name" not in tags:
                continue

            lat = element.get("lat")
            lon = element.get("lon")

            if lat is None:
                center = element.get("center")

                if center:
                    lat = center.get("lat")
                    lon = center.get("lon")

            if lat is None or lon is None:
                continue

            category = (
                tags.get("tourism")
                or tags.get("historic")
                or tags.get("amenity")
                or tags.get("leisure")
                or tags.get("natural")
                or "unknown"
            )

            imported_city = ImportedCity(
                name=city,
                country="UNKNOWN",
                latitude=lat,
                longitude=lon,
            )

            place = ImportedPlace(
                osm_id=str(element["id"]),

                slug=slugify(tags["name"]),

                category=category,

                latitude=lat,
                longitude=lon,

                city=imported_city,

                translations={
                    "en": {
                        "name": tags["name"],
                        "description": "",
                        "ai_summary": "",
                    }
                },

                website=tags.get("website"),

                opening_hours=tags.get("opening_hours"),

                wikipedia=tags.get("wikipedia"),

                wikidata=tags.get("wikidata"),
            )

            places.append(place)

        return PlaceFilter.filter(places)