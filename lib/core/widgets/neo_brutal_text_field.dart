import 'package:flutter/material.dart';
import '../theme/neo_brutal_tokens.dart';

/// Text field modern dengan sudut membulat, border rapi, dan transisi fokus halus.
class NeoBrutalTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? hint;
  final String? errorText;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const NeoBrutalTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.hint,
    this.errorText,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final effectiveHint = hintText ?? hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: tokens.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? Theme.of(context).colorScheme.error
                  : tokens.borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: tokens.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            autofocus: autofocus,
            onTap: onTap,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: keyboardType,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: InputBorder.none,
              hintText: effectiveHint,
              hintStyle: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
                color: tokens.textMuted.withValues(alpha: 0.7),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
