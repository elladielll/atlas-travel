import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onTap;

  const AppSearchBar({
    super.key,
    this.placeholder = 'Search places, cities, stories...',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.muted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                placeholder,
                style: AppTextStyles.caption.copyWith(fontSize: 15),
              ),
            ),
            const Icon(Icons.tune_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}