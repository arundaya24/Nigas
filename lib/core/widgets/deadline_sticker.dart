import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/neo_brutal_tokens.dart';

enum DeadlineStatus {
  overdue,
  today,
  tomorrow,
  upcoming,
  done,
}

/// Label tenggat waktu berbentuk stiker Neo-Brutalism:
/// Sedikit miring (±2°), garis tebal, hard shadow, teks Space Mono uppercase.
class DeadlineSticker extends StatelessWidget {
  final String text;
  final DeadlineStatus? status;
  final Color? customBgColor;
  final Color? customTextColor;
  final double rotationDegrees;

  const DeadlineSticker({
    super.key,
    required this.text,
    this.status,
    this.customBgColor,
    this.customTextColor,
    this.rotationDegrees = -2.0,
  });

  Color _resolveBgColor() {
    if (customBgColor != null) return customBgColor!;
    switch (status) {
      case DeadlineStatus.overdue:
        return AppColors.red;
      case DeadlineStatus.today:
        return AppColors.yellow;
      case DeadlineStatus.tomorrow:
        return AppColors.orange;
      case DeadlineStatus.done:
        return AppColors.lime;
      case DeadlineStatus.upcoming:
      case null:
        return const Color(0xFFE5E7EB);
    }
  }

  Color _resolveTextColor() {
    if (customTextColor != null) return customTextColor!;
    switch (status) {
      case DeadlineStatus.overdue:
        return Colors.white;
      default:
        return const Color(0xFF141414);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.neoBrutal;
    final bgColor = _resolveBgColor();
    final textColor = _resolveTextColor();

    final radians = rotationDegrees * (math.pi / 180.0);

    return Transform.rotate(
      angle: radians,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(
            color: tokens.borderColor,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: tokens.shadowColor,
              offset: const Offset(2.0, 2.0),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          style: AppTheme.monoStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

