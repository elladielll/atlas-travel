import '../../../../features/places/domain/place_entity.dart';
import '../image_provider.dart';
import '../image_result.dart';
import '../../network/http_client.dart';

class OpenverseProvider implements ImageProvider {
  final HttpClient client;

  const OpenverseProvider({
    required this.client,
  });

  @override
  Future<ImageResult?> searchPlaceImage(
    PlaceEntity place,
  ) async {
    // Пока API не подключаем
    return null;
  }
}