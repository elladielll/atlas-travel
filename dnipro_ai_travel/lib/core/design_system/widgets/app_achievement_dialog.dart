import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';

class AppAchievementDialog extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final int xp;

  const AppAchievementDialog({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.xp,
  });

  static Future<void> show(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required int xp,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => AppAchievementDialog(
        emoji: emoji,
        title: title,
        subtitle: subtitle,
        xp: xp,
      ),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.92),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Achievement unlocked',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Text(
                        '+$xp XP',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Continue'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}