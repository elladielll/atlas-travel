import hashlib

from .downloader import ImageDownloader
from .optimizer import ImageOptimizer
from .uploader import ImageUploader


class ImagePipeline:

    def __init__(self):

        self.downloader = ImageDownloader()

        self.optimizer = ImageOptimizer()

        self.uploader = ImageUploader()

    async def process(
        self,
        url: str,
    ) -> str | None:

        if not url:
            return None

        image = await self.downloader.download(url)

        if image is None:
            return None

        image = self.optimizer.optimize(image)

        filename = hashlib.md5(image).hexdigest() + ".webp"

        return await self.uploader.upload(
            filename,
            image,
        )