import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/liquid_theme.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;
  final bool enableBlobs;

  const LiquidBackground({
    super.key,
    required this.child,
    this.enableBlobs = true,
  });

  @override
  Widget build(BuildContext context) {
    final liquidTheme = Theme.of(context).extension<LiquidTheme>();
    final gradient =
        liquidTheme?.backgroundGradient ??
        const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          if (enableBlobs) ...[
            _LiquidBlob(
              color: (liquidTheme?.glowColor ?? Colors.blueAccent).withValues(
                alpha: 0.35,
              ),
              size: 220,
              top: -60,
              left: -40,
            ),
            _LiquidBlob(
              color: Colors.pinkAccent.withValues(alpha: 0.18),
              size: 180,
              top: 120,
              right: -30,
            ),
            _LiquidBlob(
              color: Colors.cyanAccent.withValues(alpha: 0.12),
              size: 260,
              bottom: -80,
              left: 40,
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _LiquidBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _LiquidBlob({
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: math.pi / 9,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0.05)],
            ),
          ),
        ),
      ),
    );
  }
}
