import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../../../core/design_system/widgets/app_category_chip.dart';
import '../../../../core/design_system/widgets/app_hero_place_card.dart';
import '../../../../core/design_system/widgets/app_search_bar.dart';
import '../../../../core/design_system/widgets/app_section_title.dart';
import '../places_providers.dart';
import '../widgets/place_list_card.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(placesProvider);

    return Scaffold(
      body: SafeArea(
        child: placesAsync.when(
          data: (places) {
            final heroPlace = places.first;
            final otherPlaces = places.skip(1).toList();

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Discover',
                        style: AppTextStyles.display,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.go('/passport'),
                      icon: const Icon(Icons.person_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Good evening, Viacheslav 👋',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppSearchBar(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Search coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      AppCategoryChip(
                        icon: Icons.auto_awesome_rounded,
                        label: 'For you',
                        selected: true,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppCategoryChip(
                        icon: Icons.park_rounded,
                        label: 'Nature',
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppCategoryChip(
                        icon: Icons.account_balance_rounded,
                        label: 'Culture',
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppCategoryChip(
                        icon: Icons.local_cafe_rounded,
                        label: 'Coffee',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current city',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Dnipro',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppHeroPlaceCard(
                  place: heroPlace,
                  onTap: () => context.push('/place', extra: heroPlace),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                const AppSectionTitle(
                  title: 'Continue Exploring',
                  subtitle: 'Places that can become your next memory',
                ),
                const SizedBox(height: AppSpacing.lg),
                ...otherPlaces.map(
                  (place) => PlaceListCard(place: place),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}