import 'package:flutter/material.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';
import '../../domain/task_status.dart';

/// Modal bottom sheet untuk memilih status tugas (To-Do / Sedang Dikerjakan / Selesai).
Future<TaskStatus?> showTaskStatusPicker(
  BuildContext context, {
  required TaskStatus currentStatus,
}) {
  final tokens = context.brutalTheme;

  return showModalBottomSheet<TaskStatus>(
    context: context,
    backgroundColor: tokens.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: tokens.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ubah Status Tugas',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...TaskStatus.values.map((status) {
                final isSelected = status == currentStatus;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(ctx).pop(status),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? status.backgroundColor
                            : tokens.scaffoldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? status.borderColor
                              : tokens.borderColor,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(status.icon, color: status.color, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              status.label,
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? status.color
                                    : tokens.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_rounded, color: status.color, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

