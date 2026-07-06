import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryDark = Color(0xFFDECBAF); // Warm Tan / Accent
  static const Color accentDark = Color(0xFFF4EBD9); // Soft Cream / Highlight
  static const Color bgDark = Color(0xFF3D0C11); // Dark Maroon/Chocolate Background
  static const Color cardDark = Color(0xFF4F141A); // Deep Maroon Card
  static const Color textPrimaryDark = Color(0xFFF4EBD9); // Soft Cream text
  static const Color textSecondaryDark = Color(0xFFDECBAF); // Warm Tan text

  static const Color primaryLight = Color(0xFF7B0828); // Luxury Burgundy
  static const Color accentLight = Color(0xFFDECBAF); // Warm Tan
  static const Color bgLight = Color(0xFFF4EBD9); // Soft Cream Background
  static const Color cardLight = Color(0xFFFFFFFF); // White Card
  static const Color textPrimaryLight = Color(0xFF3D0C11); // Dark Maroon text
  static const Color textSecondaryLight = Color(0xFF6D5A50); // Muted Cocoa text

  // Priority Colors
  static const Color priorityHigh = Color(0xFFEF4444); // Red
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber
  static const Color priorityLow = Color(0xFF10B981); // Emerald

  // Category Colors/Icons helpers
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return const Color(0xFF3B82F6); // Blue
      case 'personal':
        return const Color(0xFFEC4899); // Pink
      case 'health':
        return const Color(0xFF10B981); // Emerald
      case 'shopping':
        return const Color(0xFFF59E0B); // Amber
      default:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work_outline_rounded;
      case 'personal':
        return Icons.person_outline_rounded;
      case 'health':
        return Icons.favorite_border_rounded;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.bookmark_border_rounded;
    }
  }

  // Dark Theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: accentDark,
        background: bgDark,
        surface: cardDark,
        onBackground: textPrimaryDark,
        onSurface: textPrimaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryDark),
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryDark, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondaryDark),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryDark, fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryDark, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondaryDark, fontSize: 14),
      ),
    );
  }

  // Light Theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: primaryLight,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: accentLight,
        background: bgLight,
        surface: cardLight,
        onBackground: textPrimaryLight,
        onSurface: textPrimaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryLight),
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondaryLight),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryLight, fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryLight, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondaryLight, fontSize: 14),
      ),
    );
  }
}
