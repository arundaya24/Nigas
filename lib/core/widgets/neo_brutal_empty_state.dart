import 'package:flutter/material.dart';

import '../theme/neo_brutal_tokens.dart';
import 'neo_brutal_button.dart';

class NeoBrutalEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? message;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const NeoBrutalEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.message,
    this.action,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.assignment_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final effectiveMessage = subtitle ?? message ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: tokens.primaryAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: tokens.primaryAccent),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: tokens.textPrimary,
              ),
            ),
            if (effectiveMessage.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                effectiveMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: tokens.textMuted,
                  height: 1.4,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 18),
              action!,
            ] else if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              NeoBrutalButton(
                height: 42,
                text: actionLabel!,
                variant: NeoBrutalButtonVariant.primary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
