class CommonsService:

    async def image(
        self,
        wikidata: dict,
    ) -> str | None:

        try:
            claims = wikidata["entities"]

            entity = next(iter(claims.values()))

            image = entity["claims"]["P18"][0]

            filename = image["mainsnak"]["datavalue"]["value"]

            filename = filename.replace(" ", "_")

            return (
                "https://commons.wikimedia.org/wiki/Special:FilePath/"
                + filename
            )

        except Exception:
            return None