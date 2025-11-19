import 'package:flutter/material.dart';

class LiquidTheme extends ThemeExtension<LiquidTheme> {
  final LinearGradient backgroundGradient;
  final LinearGradient surfaceGradient;
  final LinearGradient accentSurfaceGradient;
  final Color glassBorderColor;
  final Color glowColor;
  final Color subtleTextColor;

  const LiquidTheme({
    required this.backgroundGradient,
    required this.surfaceGradient,
    required this.accentSurfaceGradient,
    required this.glassBorderColor,
    required this.glowColor,
    required this.subtleTextColor,
  });

  @override
  LiquidTheme copyWith({
    LinearGradient? backgroundGradient,
    LinearGradient? surfaceGradient,
    LinearGradient? accentSurfaceGradient,
    Color? glassBorderColor,
    Color? glowColor,
    Color? subtleTextColor,
  }) {
    return LiquidTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      surfaceGradient: surfaceGradient ?? this.surfaceGradient,
      accentSurfaceGradient:
          accentSurfaceGradient ?? this.accentSurfaceGradient,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      glowColor: glowColor ?? this.glowColor,
      subtleTextColor: subtleTextColor ?? this.subtleTextColor,
    );
  }

  @override
  LiquidTheme lerp(ThemeExtension<LiquidTheme>? other, double t) {
    if (other is! LiquidTheme) return this;

    return LiquidTheme(
      backgroundGradient:
          LinearGradient.lerp(
            backgroundGradient,
            other.backgroundGradient,
            t,
          ) ??
          backgroundGradient,
      surfaceGradient:
          LinearGradient.lerp(surfaceGradient, other.surfaceGradient, t) ??
          surfaceGradient,
      accentSurfaceGradient:
          LinearGradient.lerp(
            accentSurfaceGradient,
            other.accentSurfaceGradient,
            t,
          ) ??
          accentSurfaceGradient,
      glassBorderColor:
          Color.lerp(glassBorderColor, other.glassBorderColor, t) ??
          glassBorderColor,
      glowColor: Color.lerp(glowColor, other.glowColor, t) ?? glowColor,
      subtleTextColor:
          Color.lerp(subtleTextColor, other.subtleTextColor, t) ??
          subtleTextColor,
    );
  }
}
