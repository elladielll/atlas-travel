import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/providers/image_providers.dart';
import '../data/explore_repository.dart';
import '../domain/map_place.dart';

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepository(
    apiClient: ApiClient(
      httpClient: ref.watch(httpClientProvider),
    ),
  );
});

final exploreProvider = FutureProvider<List<MapPlace>>((ref) async {
  return ref.watch(exploreRepositoryProvider).getPlaces();
});

final selectedPlaceProvider = Provider<ValueNotifier<MapPlace?>>((ref) {
  final notifier = ValueNotifier<MapPlace?>(null);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final exploreSearchProvider = Provider<ValueNotifier<String>>((ref) {
  final notifier = ValueNotifier<String>('');
  ref.onDispose(notifier.dispose);
  return notifier;
});

final exploreCategoryProvider = Provider<ValueNotifier<String?>>((ref) {
  final notifier = ValueNotifier<String?>(null);
  ref.onDispose(notifier.dispose);
  return notifier;
});