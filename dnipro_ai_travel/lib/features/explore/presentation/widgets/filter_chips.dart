import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_radius.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../explore_provider.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNotifier = ref.watch(exploreCategoryProvider);

    return ValueListenableBuilder<String?>(
      valueListenable: categoryNotifier,
      builder: (context, selectedCategory, _) {
        return SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _MapFilterChip(
                label: 'All',
                selected: selectedCategory == null,
                onTap: () => categoryNotifier.value = null,
              ),
              const SizedBox(width: AppSpacing.sm),
              _MapFilterChip(
                label: 'Nature',
                selected: selectedCategory == 'nature',
                onTap: () => categoryNotifier.value = 'nature',
              ),
              const SizedBox(width: AppSpacing.sm),
              _MapFilterChip(
                label: 'Culture',
                selected: selectedCategory == 'culture',
                onTap: () => categoryNotifier.value = 'culture',
              ),
              const SizedBox(width: AppSpacing.sm),
              _MapFilterChip(
                label: 'Walks',
                selected: selectedCategory == 'walks',
                onTap: () => categoryNotifier.value = 'walks',
              ),
              const SizedBox(width: AppSpacing.sm),
              _MapFilterChip(
                label: 'AI Picks',
                selected: selectedCategory == 'ai',
                onTap: () => categoryNotifier.value = 'ai',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MapFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(
              fontSize: 13,
              color: selected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}