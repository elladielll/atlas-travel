import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_radius.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../../../core/design_system/widgets/app_achievement_dialog.dart';
import '../../../../core/design_system/widgets/app_ai_summary_card.dart';
import '../../../../core/design_system/widgets/app_info_pill.dart';
import '../../../../core/design_system/widgets/app_place_image.dart';
import '../../../../core/design_system/widgets/app_primary_button.dart';
import '../../../../core/design_system/widgets/app_score_badge.dart';
import '../../../../core/design_system/widgets/app_secondary_button.dart';
import '../../../../core/design_system/widgets/app_section_title.dart';
import '../../../passport/presentation/passport_providers.dart';
import '../places_providers.dart';
import '../../domain/place_entity.dart';

class PlaceDetailScreen extends ConsumerWidget {
  final PlaceEntity place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const locale = 'en';

    Future<void> markVisited() async {
  final visitsRepository = ref.read(visitsRepositoryProvider);

  final result = await visitsRepository.createVisit(placeId: place.id);

  ref.invalidate(passportVisitsProvider);

  if (!context.mounted) return;

  if (result.alreadyVisited) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This place is already in your Passport'),
      ),
    );
    return;
  }

  if (result.totalVisits == 1) {
    await AppAchievementDialog.show(
      context,
      emoji: '🌱',
      title: 'First Steps',
      subtitle: 'You added your first place to your Travel Passport.',
      xp: 50,
    );
    return;
  }

  if (result.totalVisits == 3) {
    await AppAchievementDialog.show(
      context,
      emoji: '🧭',
      title: 'Explorer',
      subtitle: 'You visited 3 places and started building your travel story.',
      xp: 100,
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Visit saved to Passport'),
    ),
  );
}

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 430,
                    child: AppPlaceImage(place: place),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x22000000),
                            Color(0x00000000),
                            Color(0xCC000000),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.xl,
                    right: AppSpacing.xl,
                    bottom: AppSpacing.xxl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppScoreBadge(score: place.aiScore, label: 'AI'),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          place.localizedName(locale),
                          style: AppTextStyles.display.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'A place worth adding to your travel story.',
                          style: AppTextStyles.subtitle.copyWith(
                            color: Colors.white.withOpacity(0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xxl,
                    AppSpacing.xl,
                    AppSpacing.xxxl,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadius.xxl),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          AppInfoPill(
                            icon: Icons.category_rounded,
                            label: 'Category',
                            value: place.category,
                          ),
                          const AppInfoPill(
                            icon: Icons.schedule_rounded,
                            label: 'Best time',
                            value: 'Sunset',
                          ),
                          const AppInfoPill(
                            icon: Icons.payments_rounded,
                            label: 'Price',
                            value: 'Free',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      AppAiSummaryCard(
                        summary: place.localizedDescription(locale),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const _CompassAdviceCard(),
                      const SizedBox(height: AppSpacing.xxl),
                      const AppSectionTitle(
                        title: 'Why visit',
                        subtitle: 'Small reasons that make this place memorable',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _ReasonCard(
                        icon: Icons.wb_twilight_rounded,
                        title: 'Beautiful at sunset',
                        description:
                            'The light near the river makes this place feel cinematic.',
                      ),
                      const _ReasonCard(
                        icon: Icons.photo_camera_rounded,
                        title: 'Great for photos',
                        description:
                            'Wide views and open space make it easy to capture memories.',
                      ),
                      const _ReasonCard(
                        icon: Icons.directions_walk_rounded,
                        title: 'Easy to explore',
                        description:
                            'A calm place for walking without needing a strict plan.',
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      AppPrimaryButton(
                        label: "I've been here",
                        icon: Icons.check_circle_rounded,
                        onPressed: markVisited,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppSecondaryButton(
                        title: 'Save for later',
                        icon: Icons.bookmark_border_rounded,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved for later')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: AppSpacing.xl,
            left: AppSpacing.xl,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassAdviceCard extends StatelessWidget {
  const _CompassAdviceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Text('🧭', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Compass says",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "This place is especially good near sunset. If you visit today, it could become your first travel memory.",
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

class _ReasonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ReasonCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}