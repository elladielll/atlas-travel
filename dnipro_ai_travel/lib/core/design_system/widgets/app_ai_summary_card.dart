import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

class AppAiSummaryCard extends StatelessWidget {
  final String title;
  final String summary;

  const AppAiSummaryCard({
    super.key,
    this.title = 'AI Summary',
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.title.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            summary,
            style: AppTextStyles.subtitle.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}