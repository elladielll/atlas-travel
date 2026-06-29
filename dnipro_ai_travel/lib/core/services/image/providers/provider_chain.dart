import '../image_provider.dart';
import '../image_result.dart';
import '../../../../features/places/domain/place_entity.dart';

class ProviderChain implements ImageProvider {
  final List<ImageProvider> providers;

  const ProviderChain({
    required this.providers,
  });

  @override
  Future<ImageResult?> searchPlaceImage(
    PlaceEntity place,
  ) async {
    for (final provider in providers) {
      try {
        final result = await provider.searchPlaceImage(place);

        if (result != null) {
          return result;
        }
      } catch (_) {
        // Пробуем следующий провайдер
      }
    }

    return null;
  }
}