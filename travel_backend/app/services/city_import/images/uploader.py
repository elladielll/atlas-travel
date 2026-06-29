class ImageUploader:

    async def upload(
        self,
        filename: str,
        image: bytes,
    ) -> str:

        # Здесь позже будет Supabase Storage

        return filename