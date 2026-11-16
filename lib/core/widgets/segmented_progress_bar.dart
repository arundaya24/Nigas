import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/neo_brutal_tokens.dart';

/// Bar progres subtugas berbentuk deretan kotak bersegmen khas Neo-Brutalism.
/// Menggantikan progress bar membulat default Material.
class SegmentedProgressBar extends StatelessWidget {
  final int total;
  final int completed;
  final Color? activeColor;
  final double height;
  final bool showLabel;

  const SegmentedProgressBar({
    super.key,
    required this.total,
    required this.completed,
    this.activeColor,
    this.height = 8.0,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();

    final tokens = context.neoBrutal;
    final fill = activeColor ?? tokens.secondaryAccent; // Default Lime Green

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah Pengerjaan',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: tokens.textMuted,
                ),
              ),
              Text(
                '$completed/$total',
                style: AppTheme.monoStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
        Row(
          children: List.generate(total, (index) {
            final isDone = index < completed;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < total - 1 ? 4.0 : 0.0,
                ),
                height: height,
                decoration: BoxDecoration(
                  color: isDone ? fill : tokens.cardBg,
                  borderRadius: BorderRadius.circular(1.0),
                  border: Border.all(
                    color: tokens.borderColor,
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

