import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../domain/map_place.dart';
import '../explore_provider.dart';

class ExploreMap extends ConsumerWidget {
  final List<MapPlace> places;

  const ExploreMap({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotifier = ref.watch(selectedPlaceProvider);

    return ValueListenableBuilder<MapPlace?>(
      valueListenable: selectedNotifier,
      builder: (context, selectedPlace, _) {
        return FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(48.4647, 35.0462),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: AppConfig.mapTileUrl,
            ),
            MarkerLayer(
              markers: places.map((place) {
                final selected = selectedPlace?.id == place.id;

                return Marker(
                  point: LatLng(place.latitude, place.longitude),
                  width: selected ? 58 : 46,
                  height: selected ? 58 : 46,
                  child: GestureDetector(
                    onTap: () {
                      selectedNotifier.value = place;
                    },
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: selected ? 1.15 : 1,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: selected ? AppColors.primary : Colors.redAccent,
                        size: selected ? 52 : 42,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}