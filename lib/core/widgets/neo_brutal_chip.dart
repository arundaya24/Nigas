import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/neo_brutal_tokens.dart';

class NeoBrutalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeTextColor;
  final Widget? leading;
  final double height;

  const NeoBrutalChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.activeTextColor,
    this.leading,
    this.height = 38.0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;

    final selectedBg = activeColor ?? AppColors.primary;
    final unselectedBg = tokens.cardBg;

    final selectedText = activeTextColor ?? Colors.white;
    final unselectedText = tokens.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? selectedBg : tokens.borderColor,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedBg.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 6)],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? selectedText : unselectedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
