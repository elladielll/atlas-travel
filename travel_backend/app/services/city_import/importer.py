import asyncio
import sys

from .commons_service import CommonsService
from .overpass_service import OverpassService
from .wikidata_service import WikidataService
from .wikipedia_service import WikipediaService

MAX_CONCURRENT_REQUESTS = 8


async def enrich_place(
    place,
    semaphore,
    wikidata,
    wikipedia,
    commons,
):

    async with semaphore:

        if place.wikidata:

            try:

                data = await wikidata.load(place.wikidata)

                if data:
                    place.image_url = await commons.image(data)

                if place.wikipedia:

                    title = place.wikipedia.split(":")[-1]

                    page = await wikipedia.summary(title)

                    if page:

                        place.description = page.get("extract")

                        place.wikipedia_url = (
                            page.get("content_urls", {})
                            .get("desktop", {})
                            .get("page")
                        )

            except Exception:
                pass

        return place


async def import_city(city: str):

    overpass = OverpassService()

    wikidata = WikidataService()

    wikipedia = WikipediaService()

    commons = CommonsService()

    places = await overpass.load_city(city)

    semaphore = asyncio.Semaphore(MAX_CONCURRENT_REQUESTS)

    tasks = [
        enrich_place(
            place,
            semaphore,
            wikidata,
            wikipedia,
            commons,
        )
        for place in places
    ]

    return await asyncio.gather(*tasks)


async def main():

    city = sys.argv[1] if len(sys.argv) > 1 else "Dnipro"

    places = await import_city(city)

    print(f"Imported {len(places)} places")

    for place in places[:20]:

        print(place.name)

        print(place.category)

        print(place.image_url)


if __name__ == "__main__":
    asyncio.run(main())