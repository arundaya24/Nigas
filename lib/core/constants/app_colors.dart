import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightShadow = Color(0x0D0F172A);

  static const Color darkBg = Color(0xFF0B1120);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkShadow = Color(0x33000000);

  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEFF6FF);

  static const Color rplPrimary = Color(0xFF64748B);
  static const Color rplLight = Color(0xFFF1F5F9);
  static const Color tkjPrimary = Color(0xFF18181B);
  static const Color tkjLight = Color(0xFFE4E4E7);
  static const Color dkvPrimary = Color(0xFF1E3A8A);
  static const Color dkvLight = Color(0xFFEFF6FF);
  static const Color generalPrimary = Color(0xFF0F766E);
  static const Color generalLight = Color(0xFFCCFBF1);

  static const Color statusTodo = Color(0xFFD97706);
  static const Color statusTodoBg = Color(0xFFFEF3C7);
  static const Color statusTodoBorder = Color(0xFFFDE68A);

  static const Color statusProgress = Color(0xFF2563EB);
  static const Color statusProgressBg = Color(0xFFDBEAFE);
  static const Color statusProgressBorder = Color(0xFFBFDBFE);

  static const Color statusDone = Color(0xFF059669);
  static const Color statusDoneBg = Color(0xFFD1FAE5);
  static const Color statusDoneBorder = Color(0xFFA7F3D0);

  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentCyan = Color(0xFF06B6D4);

  static const Color yellow = accentAmber;
  static const Color red = Color(0xFFEF4444);
  static const Color blue = accentBlue;
  static const Color lime = accentEmerald;
  static const Color pink = accentPink;
  static const Color orange = accentOrange;
  static const Color cyan = accentCyan;
  static const Color purple = accentPurple;

  static const List<Color> subjectPalette = [
    accentBlue,
    accentIndigo,
    accentPurple,
    accentPink,
    accentOrange,
    accentAmber,
    accentEmerald,
    accentCyan,
  ];

  static Color getSubjectColor(int index) {
    if (index < 0 || index >= subjectPalette.length) {
      return subjectPalette[0];
    }
    return subjectPalette[index];
  }
}
