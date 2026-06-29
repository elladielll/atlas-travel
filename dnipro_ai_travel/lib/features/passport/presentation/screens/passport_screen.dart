import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_radius.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../passport_providers.dart';

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(passportVisitsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: visitsAsync.when(
          data: (visits) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                120,
              ),
              children: [
                Text(
                  'Travel Passport',
                  style: AppTextStyles.display,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your visited places and travel memories',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _PassportStatsCard(
                  placesCount: visits.length,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Visited places',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (visits.isEmpty)
                  const _EmptyPassportCard()
                else
                  ...visits.map(
                    (visit) => _VisitedPlaceCard(visit: visit),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'Error: $error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PassportStatsCard extends StatelessWidget {
  final int placesCount;

  const _PassportStatsCard({
    required this.placesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: const Text(
              '🧭',
              style: TextStyle(fontSize: 42),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$placesCount places visited',
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Compass is collecting your story.',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitedPlaceCard extends StatelessWidget {
  final dynamic visit;

  const _VisitedPlaceCard({
    required this.visit,
  });

  @override
  Widget build(BuildContext context) {
    final place = visit['places'];
    final translations = place?['place_translations'] as List? ?? [];

    String name = 'Unknown place';

    if (translations.isNotEmpty) {
      final en = translations.firstWhere(
        (item) => item['language'] == 'en',
        orElse: () => translations.first,
      );

      name = en['name'] ?? name;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Added to your travel story',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPassportCard extends StatelessWidget {
  const _EmptyPassportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        'Visit your first place to start your travel story.',
        style: AppTextStyles.subtitle,
      ),
    );
  }
}