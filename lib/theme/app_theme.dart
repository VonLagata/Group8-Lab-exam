import 'package:flutter/material.dart';

/// InstaPost look: black & white, bordered cards, gray underlined inputs.
/// Every screen takes its colors, fonts and spacing from here.
class AppTheme {
  AppTheme._();

  // Colors (taken from the Figma design)
  static const Color black = Color(0xFF111111);
  static const Color white = Colors.white;
  static const Color field = Color(0xFFE6E6E6); // gray input background
  static const Color bodyText = Color(0xFF333333);
  static const Color hint = Color(0xFF8A8A8A);
  static const Color error = Color(0xFFD32F2F);

  // Spacing & shape
  static const double pad = 16;
  static const double radiusCard = 10;
  static const double radiusDialog = 20;
  static const double radiusButton = 6;

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// White card with a thin black border and a soft shadow.
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: black),
    boxShadow: softShadow,
  );

  /// Gray input with a black underline (used in every dialog).
  static InputDecoration inputDecoration(String? hintText) {
    const underline = UnderlineInputBorder(
      borderSide: BorderSide(color: black, width: 1.5),
    );
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: hint, fontSize: 13),
      filled: true,
      fillColor: field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: underline,
      enabledBorder: underline,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: black, width: 2.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 2.5),
      ),
      errorStyle: const TextStyle(color: error, fontSize: 12),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: black,
        onPrimary: white,
        secondary: black,
        onSecondary: white,
        surface: white,
        onSurface: black,
        error: error,
      ),
      scaffoldBackgroundColor: white,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: black),
        titleMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: black),
        bodyMedium: TextStyle(fontSize: 12, height: 1.4, color: bodyText),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: bodyText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: black,
        foregroundColor: white,
        shape: CircleBorder(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: black,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: black, thickness: 1, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: black),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: black,
        selectionHandleColor: black,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: black,
        contentTextStyle: const TextStyle(color: white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
      ),
    );
  }
}
