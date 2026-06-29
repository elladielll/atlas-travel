import '../../../core/api/api_client.dart';
import '../domain/map_place.dart';

class ExploreRepository {
  final ApiClient apiClient;

  const ExploreRepository({
    required this.apiClient,
  });

  Future<List<MapPlace>> getPlaces() async {
    final response = await apiClient.get('/map/places');

    final list = response.data as List;

    return list
        .map((e) => MapPlace.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}