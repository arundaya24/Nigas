import 'package:flutter/material.dart';

import '../../features/tasks/domain/task_status.dart';
import '../theme/app_theme.dart';

class TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;
  final VoidCallback? onTap;
  final bool compact;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = compact ? status.shortLabel : status.label;

    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 13 : 15, color: status.color),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTheme.monoStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: compact ? 12 : 14,
              color: status.color,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return badge;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: badge,
    );
  }
}
