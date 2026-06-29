import 'package:flutter/material.dart';

import '../../../features/places/domain/place_entity.dart';
import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';
import 'app_place_image.dart';
import 'app_score_badge.dart';

class AppHeroPlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;

  const AppHeroPlaceCard({
    super.key,
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const locale = 'en';

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      onTap: onTap,
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [
            Positioned.fill(
              child: AppPlaceImage(
                place: place,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x99000000),
                      Color(0xDD000000),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: AppSpacing.xl,
              left: AppSpacing.xl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  "AI Recommendation",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            Positioned(
              top: AppSpacing.xl,
              right: AppSpacing.xl,
              child: AppScoreBadge(
                score: place.aiScore,
                label: "AI",
              ),
            ),

            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: AppSpacing.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.localizedName(locale),
                    style: AppTextStyles.display.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    "Perfect for your next story",
                    style: AppTextStyles.subtitle.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    children: [
                      const Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Explore",
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}