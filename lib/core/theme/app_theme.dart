import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'liquid_theme.dart';

class AppTheme {
  static const primaryColor = Color(0xFF5C6BFF);
  static const darkPrimaryColor = Color(0xFF8AB4FF);

  static final _textTheme = GoogleFonts.poppinsTextTheme();

  static ThemeData _baseTheme({
    required bool isDark,
    required Color primary,
    required LinearGradient background,
    required LinearGradient surface,
    required LinearGradient accentSurface,
    required Color borderColor,
    required Color glowColor,
    required Color subtleText,
    required Color scaffoldColor,
    required Color inputFill,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: _textTheme,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: subtleText),
      ),
      extensions: [
        LiquidTheme(
          backgroundGradient: background,
          surfaceGradient: surface,
          accentSurfaceGradient: accentSurface,
          glassBorderColor: borderColor,
          glowColor: glowColor,
          subtleTextColor: subtleText,
        ),
      ],
    );
  }

  static final lightTheme = _baseTheme(
    isDark: false,
    primary: primaryColor,
    background: const LinearGradient(
      colors: [Color(0xFFF0F4FF), Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surface: const LinearGradient(
      colors: [Color(0xE6FFFFFF), Color(0xB3F6F7FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentSurface: const LinearGradient(
      colors: [Color(0xFF7C4DFF), Color(0xFF2962FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderColor: Colors.white.withValues(alpha: 0.6),
    glowColor: const Color(0xFF7C4DFF),
    subtleText: Colors.black.withValues(alpha: 0.5),
    scaffoldColor: Colors.transparent,
    inputFill: Colors.white.withValues(alpha: 0.6),
  );

  static final darkTheme = _baseTheme(
    isDark: true,
    primary: darkPrimaryColor,
    background: const LinearGradient(
      colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF1E1B4B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surface: const LinearGradient(
      colors: [Color(0x59FFFFFF), Color(0x266B7CFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentSurface: const LinearGradient(
      colors: [Color(0xFF8AB4FF), Color(0xFF5C6BFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderColor: Colors.white.withValues(alpha: 0.25),
    glowColor: const Color(0xFF4F46E5),
    subtleText: Colors.white70,
    scaffoldColor: Colors.transparent,
    inputFill: const Color(0xFF1E293B),
  );
}
