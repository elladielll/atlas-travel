import '../../../core/api/api_client.dart';
import '../../../core/api/api_routes.dart';
import '../domain/place_entity.dart';

class PlacesRepository {
  final ApiClient apiClient;

  PlacesRepository({
    required this.apiClient,
  });

  Future<List<PlaceEntity>> getPlaces() async {
    final response = await apiClient.get(ApiRoutes.places);

    final List<dynamic> data = response.data;

    return data
        .map((e) => PlaceEntity.fromJson(e))
        .toList();
  }
}