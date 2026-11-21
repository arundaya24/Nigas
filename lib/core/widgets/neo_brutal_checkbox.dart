import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/neo_brutal_tokens.dart';

class NeoBrutalCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final double size;

  const NeoBrutalCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.size = 24.0,
  });

  @override
  State<NeoBrutalCheckbox> createState() => _NeoBrutalCheckboxState();
}

class _NeoBrutalCheckboxState extends State<NeoBrutalCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeoBrutalCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onChanged == null) return;
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final isEnabled = widget.onChanged != null;

    final effectiveActiveColor = widget.activeColor ?? AppColors.accentEmerald;
    final effectiveCheckColor = widget.checkColor ?? Colors.white;

    return Semantics(
      enabled: isEnabled,
      label: widget.value ? 'Tugas selesai' : 'Tugas belum selesai',
      child: InkResponse(
        onTap: isEnabled ? _handleTap : null,
        radius: 24.0,
        child: Container(
          width: 44.0,
          height: 44.0,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.value ? effectiveActiveColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.value ? effectiveActiveColor : tokens.borderColor,
                width: 1.5,
              ),
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.check,
                size: widget.size * 0.75,
                color: effectiveCheckColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
