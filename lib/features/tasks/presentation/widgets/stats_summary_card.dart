import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';
import '../../domain/task_status.dart';
import '../tasks_providers.dart';

/// Kartu ringkasan status tugas (Belum, Sedang, Selesai) yang dapat diklik untuk filter.
class StatsSummaryCard extends StatelessWidget {
  final TaskStats stats;
  final TaskStatus? selectedStatus;
  final ValueChanged<TaskStatus?> onSelectStatus;

  const StatsSummaryCard({
    super.key,
    required this.stats,
    required this.selectedStatus,
    required this.onSelectStatus,
  });

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
    required TaskStatus? statusValue,
  }) {
    final tokens = context.brutalTheme;
    final isSelected = selectedStatus == statusValue;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (isSelected) {
            onSelectStatus(null); // Reset filter
          } else {
            onSelectStatus(statusValue);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : tokens.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : tokens.borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : tokens.shadowColor,
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const Spacer(),
                  Text(
                    count.toString(),
                    style: AppTheme.monoStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : tokens.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildStatItem(
            context: context,
            label: 'Belum',
            count: stats.todo,
            color: AppColors.statusTodo,
            bgColor: AppColors.statusTodoBg,
            icon: Icons.schedule_rounded,
            statusValue: TaskStatus.todo,
          ),
          const SizedBox(width: 8),
          _buildStatItem(
            context: context,
            label: 'Sedang',
            count: stats.inProgress,
            color: AppColors.statusProgress,
            bgColor: AppColors.statusProgressBg,
            icon: Icons.timelapse_rounded,
            statusValue: TaskStatus.inProgress,
          ),
          const SizedBox(width: 8),
          _buildStatItem(
            context: context,
            label: 'Selesai',
            count: stats.done,
            color: AppColors.statusDone,
            bgColor: AppColors.statusDoneBg,
            icon: Icons.check_circle_rounded,
            statusValue: TaskStatus.done,
          ),
        ],
      ),
    );
  }
}

