import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/places/domain/place_entity.dart';
import '../../providers/image_providers.dart';
import '../app_colors.dart';
import '../app_radius.dart';

class AppPlaceImage extends ConsumerWidget {
  final PlaceEntity place;
  final BorderRadius? borderRadius;

  const AppPlaceImage({
    super.key,
    required this.place,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);

    return FutureBuilder(
      future: imageService.getPlaceImage(place),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _placeholder();
        }

        final image = snapshot.data;

        if (image == null) {
          return _placeholder();
        }

        return ClipRRect(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppRadius.xxl),
          child: CachedNetworkImage(
            imageUrl: image.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => _placeholder(),
            errorWidget: (_, __, ___) => _placeholder(),
          ),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primarySoft,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}