import 'package:flutter/material.dart';

class AppTheme {
  // Identitas warna Halo Minna
  static const Color navy = Color(0xFF0B2D50);
  static const Color navyDark = Color(0xFF071E35);
  static const Color blue = Color(0xFF1D527F);
  static const Color gold = Color(0xFFD7A64A);

  // Light mode
  static const Color lightCanvas = Color(0xFFF4F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInk = Color(0xFF1B2B3D);
  static const Color lightMuted = Color(0xFF66778A);
  static const Color lightLine = Color(0xFFE2E8F0);

  // Dark mode
  static const Color darkCanvas = Color(0xFF0B1726);
  static const Color darkSurface = Color(0xFF142438);
  static const Color darkInk = Color(0xFFE6EDF5);
  static const Color darkMuted = Color(0xFFA8B7C8);
  static const Color darkLine = Color(0xFF293D53);

  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: navy,
          brightness: Brightness.light,
        ).copyWith(
          primary: navy,
          onPrimary: Colors.white,
          secondary: gold,
          onSecondary: navyDark,
          surface: lightSurface,
          onSurface: lightInk,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightCanvas,

      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: navy,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lightLine),
        ),
      ),

      dividerTheme: const DividerThemeData(color: lightLine, thickness: 1),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navy, width: 1.5),
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightInk),
        bodyMedium: TextStyle(color: lightInk),
        bodySmall: TextStyle(color: lightMuted),
        titleLarge: TextStyle(color: lightInk, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: lightInk, fontWeight: FontWeight.w600),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF8BB9E5),
          onPrimary: navyDark,
          secondary: const Color(0xFFF2BD55),
          onSecondary: navyDark,
          surface: darkSurface,
          onSurface: darkInk,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkCanvas,

      appBarTheme: const AppBarTheme(
        backgroundColor: darkCanvas,
        foregroundColor: darkInk,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: darkLine),
        ),
      ),

      dividerTheme: const DividerThemeData(color: darkLine, thickness: 1),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8BB9E5), width: 1.5),
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkInk),
        bodyMedium: TextStyle(color: darkInk),
        bodySmall: TextStyle(color: darkMuted),
        titleLarge: TextStyle(color: darkInk, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: darkInk, fontWeight: FontWeight.w600),
      ),
    );
  }
}
