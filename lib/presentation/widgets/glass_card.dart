import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/liquid_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Gradient? gradient;
  final bool showGlow;

  const GlassCard({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 20.0,
    this.padding,
    this.borderRadius = 24.0,
    this.gradient,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final liquidTheme = Theme.of(context).extension<LiquidTheme>();
    final fallbackColor = isDark ? Colors.white : Colors.black;
    final baseGradient =
        gradient ??
        liquidTheme?.surfaceGradient ??
        LinearGradient(
          colors: [
            fallbackColor.withValues(alpha: opacity * 1.5),
            fallbackColor.withValues(alpha: opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    final borderColor =
        liquidTheme?.glassBorderColor ?? fallbackColor.withValues(alpha: 0.25);
    final glowColor = liquidTheme?.glowColor ?? fallbackColor;

    final clipBorder = BorderRadius.circular(borderRadius);

    final card = ClipRRect(
      borderRadius: clipBorder,
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: baseGradient,
            borderRadius: clipBorder,
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: clipBorder,
              boxShadow: showGlow
                  ? [
                      BoxShadow(
                        color: glowColor.withValues(
                          alpha: isDark ? 0.22 : 0.16,
                        ),
                        blurRadius: 28,
                        spreadRadius: 2,
                        offset: const Offset(0, 16),
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );

    return RepaintBoundary(child: card);
  }
}
