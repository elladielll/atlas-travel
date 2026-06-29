import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_radius.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../../../core/design_system/widgets/app_glass_card.dart';
import '../explore_provider.dart';

class MapSearchBar extends ConsumerWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = ref.watch(exploreSearchProvider);

    return AppGlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      radius: AppRadius.xxl,
      child: TextField(
        onChanged: (value) {
          searchNotifier.value = value;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.muted),
          hintText: 'Search places on map...',
          hintStyle: AppTextStyles.caption.copyWith(fontSize: 15),
          suffixIcon: const Icon(Icons.tune_rounded, color: AppColors.primary),
        ),
      ),
    );
  }
}