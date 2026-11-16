import 'package:flutter/material.dart';
import '../theme/neo_brutal_tokens.dart';

/// Kartu modern dengan sudut membulat halus, border rapi, dan bayangan lembut.
class NeoBrutalCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final double? borderRadius;

  const NeoBrutalCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.borderColor,
    this.shadowColor,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<NeoBrutalCard> createState() => _NeoBrutalCardState();
}

class _NeoBrutalCardState extends State<NeoBrutalCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final radius = widget.borderRadius ?? tokens.borderRadius;
    final effectiveBg = widget.color ?? tokens.cardBg;
    final effectiveBorder = widget.borderColor ?? tokens.borderColor;

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: effectiveBorder,
          width: tokens.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor ?? tokens.shadowColor,
            blurRadius: _isHovered ? 12 : 8,
            offset: _isHovered ? const Offset(0, 4) : const Offset(0, 2),
          ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap == null) {
      return Padding(
        padding: widget.margin,
        child: content,
      );
    }

    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: content,
        ),
      ),
    );
  }
}
