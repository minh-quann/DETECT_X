import 'package:flutter/material.dart';

import '../../core/theme/liquid_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final liquidTheme = Theme.of(context).extension<LiquidTheme>();
    final gradient =
        liquidTheme?.accentSurfaceGradient ??
        LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        );

    final buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          );

    final button = SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: (liquidTheme?.glowColor ?? Theme.of(context).primaryColor)
                  .withValues(alpha: 0.35),
              blurRadius: 25,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: buttonChild,
          ),
        ),
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
