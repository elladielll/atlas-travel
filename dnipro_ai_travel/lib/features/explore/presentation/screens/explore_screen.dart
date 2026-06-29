import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../places/presentation/places_providers.dart';
import '../explore_provider.dart';
import '../widgets/explore_map.dart';
import '../widgets/filter_chips.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/place_preview_card.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(exploreProvider);
    final selectedPlaceNotifier = ref.watch(selectedPlaceProvider);
    final searchNotifier = ref.watch(exploreSearchProvider);
    final categoryNotifier = ref.watch(exploreCategoryProvider);

    return Scaffold(
      body: placesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (places) {
          return ValueListenableBuilder<String>(
            valueListenable: searchNotifier,
            builder: (context, search, _) {
              return ValueListenableBuilder<String?>(
                valueListenable: categoryNotifier,
                builder: (context, category, _) {
                  final query = search.trim().toLowerCase();

                  final filteredPlaces = places.where((place) {
                    final matchesSearch = query.isEmpty ||
                        place.name.toLowerCase().contains(query) ||
                        place.category.toLowerCase().contains(query);

                    final matchesCategory = category == null ||
                        category == 'ai' && place.aiScore >= 9.0 ||
                        place.category.toLowerCase() == category;

                    return matchesSearch && matchesCategory;
                  }).toList();

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ExploreMap(places: filteredPlaces),
                      ),
                      const Positioned(
                        top: 54,
                        left: 20,
                        right: 20,
                        child: MapSearchBar(),
                      ),
                      const Positioned(
                        top: 122,
                        left: 20,
                        right: 0,
                        child: FilterChips(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ValueListenableBuilder(
                          valueListenable: selectedPlaceNotifier,
                          builder: (context, selectedPlace, child) {
                            if (selectedPlace == null) {
                              return const SizedBox.shrink();
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 240),
                              child: PlacePreviewCard(
                                key: ValueKey(selectedPlace.id),
                                place: selectedPlace,
                                onOpen: () {
                                  final placesState = ref.read(placesProvider);

                                  placesState.whenData((allPlaces) {
                                    final placeEntity = allPlaces.firstWhere(
                                      (item) => item.id == selectedPlace.id,
                                    );

                                    context.push('/place', extra: placeEntity);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}