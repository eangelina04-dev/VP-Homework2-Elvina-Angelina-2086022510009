import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const starYellow = Color(0xFFF5D547); // kuning tombol di starwars.com
  static const barGray = Color(0xFF4D4D4D); // abu-abu bar filter

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: starYellow,
      brightness: Brightness.dark,
    ).copyWith(
      primary: starYellow,
      onPrimary: black,
      secondary: white,
      onSecondary: black,
      secondaryContainer: barGray, // warna chip yang dipilih
      onSecondaryContainer: white,
      tertiary: starYellow,
      onTertiary: black,
      surface: black,
      onSurface: white,
      onSurfaceVariant: const Color(0xFFB3B3B3),
      surfaceContainerLow: const Color(0xFF121212), // warna Card
      surfaceContainerHigh: const Color(0xFF1E1E1E), // warna kolom cari
      outlineVariant: const Color(0xFF333333),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: black,
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: scheme.outlineVariant),
      ),
    );
  }
}