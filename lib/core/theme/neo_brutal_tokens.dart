import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Token desain Nigas yang bersih, modern, dan enak dipandang.
/// Mendukung mode Terang & Gelap dengan kontras nyaman dan radius ramah.
class NeoBrutalTokens extends ThemeExtension<NeoBrutalTokens> {
  final Color scaffoldBg;
  final Color cardBg;
  final Color textPrimary;
  final Color textMuted;
  final Color borderColor;
  final Color shadowColor;
  final Color primaryAccent;
  final Color secondaryAccent;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final Offset pressedShadowOffset;

  const NeoBrutalTokens({
    required this.scaffoldBg,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.borderColor,
    required this.shadowColor,
    required this.primaryAccent,
    required this.secondaryAccent,
    this.borderWidth = 1.0,
    this.borderRadius = 16.0,
    this.shadowOffset = const Offset(0.0, 3.0),
    this.pressedShadowOffset = const Offset(0.0, 1.0),
  });

  /// Mode Terang: Bersih, cerah, bayangan halus, sudut membulat 16px
  factory NeoBrutalTokens.light() {
    return const NeoBrutalTokens(
      scaffoldBg: AppColors.lightBg,
      cardBg: AppColors.lightCard,
      textPrimary: AppColors.lightText,
      textMuted: AppColors.lightTextMuted,
      borderColor: AppColors.lightBorder,
      shadowColor: AppColors.lightShadow,
      primaryAccent: AppColors.primary,
      secondaryAccent: AppColors.accentIndigo,
      borderWidth: 1.0,
      borderRadius: 16.0,
      shadowOffset: Offset(0.0, 3.0),
      pressedShadowOffset: Offset(0.0, 1.0),
    );
  }

  /// Mode Gelap: Slate gelap nyaman, kartu bergradien lembut, kontras tinggi
  factory NeoBrutalTokens.dark() {
    return const NeoBrutalTokens(
      scaffoldBg: AppColors.darkBg,
      cardBg: AppColors.darkCard,
      textPrimary: AppColors.darkText,
      textMuted: AppColors.darkTextMuted,
      borderColor: AppColors.darkBorder,
      shadowColor: AppColors.darkShadow,
      primaryAccent: AppColors.primary,
      secondaryAccent: AppColors.accentIndigo,
      borderWidth: 1.0,
      borderRadius: 16.0,
      shadowOffset: Offset(0.0, 3.0),
      pressedShadowOffset: Offset(0.0, 1.0),
    );
  }

  @override
  ThemeExtension<NeoBrutalTokens> copyWith({
    Color? scaffoldBg,
    Color? cardBg,
    Color? textPrimary,
    Color? textMuted,
    Color? borderColor,
    Color? shadowColor,
    Color? primaryAccent,
    Color? secondaryAccent,
    double? borderWidth,
    double? borderRadius,
    Offset? shadowOffset,
    Offset? pressedShadowOffset,
  }) {
    return NeoBrutalTokens(
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      cardBg: cardBg ?? this.cardBg,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      secondaryAccent: secondaryAccent ?? this.secondaryAccent,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      pressedShadowOffset: pressedShadowOffset ?? this.pressedShadowOffset,
    );
  }

  @override
  ThemeExtension<NeoBrutalTokens> lerp(
    covariant ThemeExtension<NeoBrutalTokens>? other,
    double t,
  ) {
    if (other is! NeoBrutalTokens) return this;
    return NeoBrutalTokens(
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      borderWidth:
          borderWidth + (other.borderWidth - borderWidth) * t,
      borderRadius:
          borderRadius + (other.borderRadius - borderRadius) * t,
      shadowOffset: Offset.lerp(shadowOffset, other.shadowOffset, t)!,
      pressedShadowOffset:
          Offset.lerp(pressedShadowOffset, other.pressedShadowOffset, t)!,
    );
  }
}

extension NeoBrutalContextX on BuildContext {
  NeoBrutalTokens get brutalTheme {
    final tokens = Theme.of(this).extension<NeoBrutalTokens>();
    return tokens ?? NeoBrutalTokens.light();
  }

  NeoBrutalTokens get neoBrutal => brutalTheme;
}
