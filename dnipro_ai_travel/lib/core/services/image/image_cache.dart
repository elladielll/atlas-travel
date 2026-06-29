import 'image_result.dart';

class ImageCacheService {
  final Map<String, ImageResult> _memoryCache = {};

  ImageResult? get(String key) {
    return _memoryCache[key];
  }

  void save(
    String key,
    ImageResult result,
  ) {
    _memoryCache[key] = result;
  }

  void clear() {
    _memoryCache.clear();
  }
}