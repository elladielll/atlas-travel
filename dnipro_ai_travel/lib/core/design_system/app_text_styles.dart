import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.ink,
  );

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.ink,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.muted,
    height: 1.4,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.ink,
    height: 1.45,
  );

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.muted,
    height: 1.35,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );
}