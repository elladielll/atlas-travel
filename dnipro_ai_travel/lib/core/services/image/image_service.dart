import '../../../features/places/domain/place_entity.dart';
import 'image_cache.dart';
import 'image_provider.dart';
import 'image_result.dart';

class ImageService {
  final ImageProvider provider;
  final ImageCacheService cache;

  const ImageService({
    required this.provider,
    required this.cache,
  });

  Future<ImageResult?> getPlaceImage(
    PlaceEntity place,
  ) async {
    final cached = cache.get(place.id);

    if (cached != null) {
      return cached;
    }

    final result = await provider.searchPlaceImage(place);

    if (result != null) {
      cache.save(place.id, result);
    }

    return result;
  }
}