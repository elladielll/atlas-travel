import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../companion_provider.dart';
import '../widgets/companion_card.dart';

class CompanionScreen extends ConsumerWidget {
  const CompanionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(companionProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(companionProvider);
            await ref.read(companionProvider.future);
          },
          child: dashboardAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (dashboard) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  Text(
                    'Companion',
                    style: AppTextStyles.display,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Your personal AI travel guide',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  CompanionCard(
                    dashboard: dashboard,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _MissionCard(
                    title: dashboard.mission.title,
                    xp: dashboard.mission.xp,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _AchievementCard(
                    emoji: dashboard.achievement.emoji,
                    title: dashboard.achievement.title,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FilledButton.icon(
                    onPressed: () {
                      context.push('/companion/chat');
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text("Ask Atlas"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final String title;
  final int xp;

  const _MissionCard({
    required this.title,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.flag),
        title: Text(title),
        subtitle: Text("+$xp XP"),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String emoji;
  final String title;

  const _AchievementCard({
    required this.emoji,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(title),
        subtitle: const Text("Latest achievement"),
      ),
    );
  }
}