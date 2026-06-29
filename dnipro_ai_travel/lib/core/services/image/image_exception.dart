class ImageException implements Exception {
  final String message;

  const ImageException(this.message);

  @override
  String toString() => message;
}