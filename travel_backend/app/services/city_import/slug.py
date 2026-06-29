import re
import unicodedata


def slugify(text: str) -> str:

    text = unicodedata.normalize("NFKD", text)

    text = text.encode("ascii", "ignore").decode()

    text = text.lower()

    text = re.sub(r"[^a-z0-9]+", "-", text)

    text = re.sub(r"-+", "-", text)

    return text.strip("-")