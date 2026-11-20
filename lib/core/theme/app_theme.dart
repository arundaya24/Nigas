import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'neo_brutal_tokens.dart';

class AppTheme {
  AppTheme._();

  static const String fontHeading = 'SpaceGrotesk';
  static const String fontMono = 'SpaceMono';

  static TextStyle monoStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 0.3,
  }) {
    return TextStyle(
      fontFamily: fontMono,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    final tokens = NeoBrutalTokens.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: tokens.scaffoldBg,
      primaryColor: AppColors.primary,
      fontFamily: fontHeading,
      extensions: [tokens],

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accentIndigo,
        onSecondary: Colors.white,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightText,
        error: Color(0xFFEF4444),
        onError: Colors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: tokens.scaffoldBg,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: fontHeading,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightText,
          letterSpacing: -0.3,
        ),
      ),

      cardTheme: CardThemeData(
        color: tokens.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.borderRadius),
          side: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: tokens.cardBg,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.borderRadius),
          side: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: fontHeading,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.lightText,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.lightTextMuted,
          height: 1.4,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.lightTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    final tokens = NeoBrutalTokens.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: tokens.scaffoldBg,
      primaryColor: AppColors.primary,
      fontFamily: fontHeading,
      extensions: [tokens],

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accentIndigo,
        onSecondary: Colors.white,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkText,
        error: Color(0xFFEF4444),
        onError: Colors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: tokens.scaffoldBg,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: fontHeading,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
          letterSpacing: -0.3,
        ),
      ),

      cardTheme: CardThemeData(
        color: tokens.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.borderRadius),
          side: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: tokens.cardBg,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.borderRadius),
          side: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: fontHeading,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.darkTextMuted,
          height: 1.4,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.darkTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
