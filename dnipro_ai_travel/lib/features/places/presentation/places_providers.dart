import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/providers/image_providers.dart';

import '../data/places_repository.dart';
import '../data/visits_repository.dart';
import '../domain/place_entity.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    httpClient: ref.watch(httpClientProvider),
  );
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  return PlacesRepository(
    apiClient: ref.watch(apiClientProvider),
  );
});

final visitsRepositoryProvider = Provider<VisitsRepository>((ref) {
  return VisitsRepository(
    apiClient: ref.watch(apiClientProvider),
  );
});

final placesProvider = FutureProvider<List<PlaceEntity>>((ref) async {
  final repository = ref.watch(placesRepositoryProvider);

  return repository.getPlaces();
});