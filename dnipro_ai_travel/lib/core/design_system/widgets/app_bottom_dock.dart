import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';

class AppBottomDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppBottomDock({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _DockItem(icon: Icons.explore_rounded, label: 'Discover'),
      _DockItem(icon: Icons.map_rounded, label: 'Map'),
      _DockItem(icon: Icons.auto_awesome_rounded, label: 'AI'),
      _DockItem(icon: Icons.person_rounded, label: 'Passport'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                border: Border.all(
                  color: Colors.white.withOpacity(0.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final selected = selectedIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        height: 54,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.ink
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: selected
                                  ? Colors.white
                                  : AppColors.muted,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: selected
                                    ? Colors.white
                                    : AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem {
  final IconData icon;
  final String label;

  const _DockItem({
    required this.icon,
    required this.label,
  });
}