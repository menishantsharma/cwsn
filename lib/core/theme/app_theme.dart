import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //--------------------------------------
  // Colors
  //--------------------------------------

  static const Color primary = Color(0xFFFF385C);
  static const Color surface = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}

extension ThemeExtras on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
}
