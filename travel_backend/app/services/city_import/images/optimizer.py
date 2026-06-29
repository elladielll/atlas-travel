from io import BytesIO

from PIL import Image


class ImageOptimizer:

    def optimize(self, image: bytes) -> bytes:

        img = Image.open(BytesIO(image))

        img.thumbnail((1600, 1600))

        output = BytesIO()

        img.save(
            output,
            format="WEBP",
            quality=85,
            method=6,
        )

        return output.getvalue()