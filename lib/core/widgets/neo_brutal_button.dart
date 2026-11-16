import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/neo_brutal_tokens.dart';

enum NeoBrutalButtonVariant {
  primary,
  secondary,
  danger,
  success,
}

/// Tombol modern dengan sudut membulat, bayangan halus, dan responsif.
class NeoBrutalButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;
  final Widget? icon;
  final NeoBrutalButtonVariant variant;
  final Color? customBgColor;
  final Color? customTextColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;

  const NeoBrutalButton({
    super.key,
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.variant = NeoBrutalButtonVariant.primary,
    this.customBgColor,
    this.customTextColor,
    this.width,
    this.height = 48.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 18.0),
  }) : assert(
          child != null || text != null,
          'Either child or text must be provided',
        );

  @override
  State<NeoBrutalButton> createState() => _NeoBrutalButtonState();
}

class _NeoBrutalButtonState extends State<NeoBrutalButton> {
  bool _isPressed = false;

  Color _resolveBgColor(NeoBrutalTokens tokens) {
    if (widget.customBgColor != null) return widget.customBgColor!;
    switch (widget.variant) {
      case NeoBrutalButtonVariant.primary:
        return AppColors.primary;
      case NeoBrutalButtonVariant.secondary:
        return tokens.cardBg;
      case NeoBrutalButtonVariant.danger:
        return const Color(0xFFEF4444);
      case NeoBrutalButtonVariant.success:
        return AppColors.accentEmerald;
    }
  }

  Color _resolveTextColor(NeoBrutalTokens tokens) {
    if (widget.customTextColor != null) return widget.customTextColor!;
    switch (widget.variant) {
      case NeoBrutalButtonVariant.primary:
      case NeoBrutalButtonVariant.danger:
      case NeoBrutalButtonVariant.success:
        return Colors.white;
      case NeoBrutalButtonVariant.secondary:
        return tokens.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final isEnabled = widget.onPressed != null;
    final bgColor = isEnabled
        ? _resolveBgColor(tokens)
        : tokens.borderColor.withValues(alpha: 0.5);
    final textColor = isEnabled
        ? _resolveTextColor(tokens)
        : tokens.textMuted;

    final isSecondary = widget.variant == NeoBrutalButtonVariant.secondary;

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSecondary ? tokens.borderColor : Colors.transparent,
                width: 1,
              ),
              boxShadow: isEnabled && !isSecondary
                  ? [
                      BoxShadow(
                        color: bgColor.withValues(alpha: 0.25),
                        blurRadius: _isPressed ? 4 : 8,
                        offset: _isPressed ? const Offset(0, 1) : const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(color: textColor, size: 18),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.text != null)
                  Text(
                    widget.text!,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  )
                else
                  widget.child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
