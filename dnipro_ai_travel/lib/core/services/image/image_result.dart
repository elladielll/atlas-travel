class ImageResult {
  final String imageUrl;
  final String? pageUrl;
  final String? author;
  final String? license;
  final String? source;

  const ImageResult({
    required this.imageUrl,
    this.pageUrl,
    this.author,
    this.license,
    this.source,
  });
}