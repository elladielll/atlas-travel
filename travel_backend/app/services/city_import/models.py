from dataclasses import dataclass, field


@dataclass
class ImportedCity:
    name: str
    country: str
    latitude: float
    longitude: float


@dataclass
class ImportedPlace:
    osm_id: str

    slug: str

    category: str

    latitude: float
    longitude: float

    city: ImportedCity

    translations: dict[str, dict] = field(default_factory=dict)

    website: str | None = None
    opening_hours: str | None = None

    wikipedia: str | None = None
    wikidata: str | None = None

    image_url: str | None = None