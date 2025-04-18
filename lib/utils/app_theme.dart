import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Primary color and its shades
  static const Color primaryColor = Color(0xFF0B8457);
  static const Color primaryLightColor = Color(0xFF5CB990);
  static const Color primaryDarkColor = Color(0xFF005A2B);
  
  // Secondary color and its shades
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color secondaryLightColor = Color(0xFF80E27E);
  static const Color secondaryDarkColor = Color(0xFF087F23);
  
  // Accent color
  static const Color accentColor = Color(0xFFFFEB3B);
  
  // Other colors
  static const Color textColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
  
  // Light color scheme
  static final ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    primaryContainer: primaryLightColor,
    secondary: secondaryColor,
    secondaryContainer: secondaryLightColor,
    surface: surfaceColor,
    background: backgroundColor,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: textColor,
    onBackground: textColor,
    onError: Colors.white,
    brightness: Brightness.light,
  );
  
  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Border radius
  static BorderRadius get borderRadius => BorderRadius.circular(12);
  
  // Button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
}