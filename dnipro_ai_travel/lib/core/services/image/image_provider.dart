import '../../../features/places/domain/place_entity.dart';
import 'image_result.dart';

abstract class ImageProvider {
  Future<ImageResult?> searchPlaceImage(
    PlaceEntity place,
  );
}