import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color textSecondary;
  final Color surfaceCard;
  final Color brandPrimary;
  final Color success;
  final Color warning;
  

  const AppColors({
    required this.textSecondary,
    required this.surfaceCard,
    required this.brandPrimary,
    required this.success,
    required this.warning,
  });

  @override
  AppColors copyWith({
    Color? textSecondary,
    Color? surfaceCard,
    Color? brandPrimary,
    Color? success,
    Color? warning,
  }) {
    return AppColors(
      textSecondary: textSecondary ?? this.textSecondary,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
