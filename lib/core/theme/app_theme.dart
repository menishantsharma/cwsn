import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFFFF385C);
  static const Color surface = Colors.white;
  static const Color _onSurface = Color(0xDD000000); // Colors.black87

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: primary);
    final textTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFFFBFBFB),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      // ── AppBar ──────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: false,
        iconTheme: const IconThemeData(color: _onSurface, size: 20),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: _onSurface,
        ),
      ),

      // ── M3 NavigationBar ────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        height: 70,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: colorScheme.primary,
            );
          }
          return textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: Colors.grey.shade500,
          );
        }),
      ),
    );
  }
}

extension ThemeExtras on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
}
