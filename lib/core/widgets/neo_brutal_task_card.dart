import 'package:flutter/material.dart';
import '../../features/tasks/domain/task_status.dart';
import '../theme/app_theme.dart';
import '../theme/neo_brutal_tokens.dart';
import 'deadline_sticker.dart';
import 'neo_brutal_card.dart';
import 'neo_brutal_checkbox.dart';
import 'segmented_progress_bar.dart';
import 'task_status_badge.dart';

/// Kartu tugas modern, bersih, dan enak dipandang:
/// - Strip warna mapel di sisi kiri
/// - Tag mapel & kategori jurusan
/// - Judul tugas (coret saat selesai)
/// - Status badge interaktif (Belum / Sedang / Selesai)
/// - Label deadline & progres subtugas
class NeoBrutalTaskCard extends StatelessWidget {
  final String title;
  final String subjectName;
  final Color subjectColor;
  final String? categoryLabel;
  final Color? categoryColor;
  final String? deadlineLabel;
  final DeadlineStatus? deadlineStatus;
  final TaskStatus status;
  final bool isDone;
  final ValueChanged<bool>? onToggleDone;
  final VoidCallback? onStatusTap;
  final VoidCallback? onTap;
  final int totalSubtasks;
  final int completedSubtasks;
  final String? notes;

  const NeoBrutalTaskCard({
    super.key,
    required this.title,
    required this.subjectName,
    required this.subjectColor,
    this.categoryLabel,
    this.categoryColor,
    this.deadlineLabel,
    this.deadlineStatus,
    this.status = TaskStatus.todo,
    this.isDone = false,
    this.onToggleDone,
    this.onStatusTap,
    this.onTap,
    this.totalSubtasks = 0,
    this.completedSubtasks = 0,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final isCompleted = isDone || status == TaskStatus.done;

    return NeoBrutalCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 12.0),
      borderRadius: 16.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Strip warna mapel di sisi kiri
              Container(
                width: 6.0,
                color: subjectColor,
              ),

              // Konten Utama Kartu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Baris 1: Kategori & Tag Mapel + Status Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (categoryLabel != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: (categoryColor ?? tokens.primaryAccent).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                categoryLabel!.toUpperCase(),
                                style: AppTheme.monoStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: categoryColor ?? tokens.primaryAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: subjectColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                subjectName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.5,
                                  color: tokens.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Badge Status interaktif
                          TaskStatusBadge(
                            status: status,
                            compact: true,
                            onTap: onStatusTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Baris 2: Checkbox + Judul Tugas
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NeoBrutalCheckbox(
                            value: isCompleted,
                            onChanged: onToggleDone,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  color: isCompleted
                                      ? tokens.textMuted
                                      : tokens.textPrimary,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Baris 3: Catatan Singkat (jika ada)
                      if (notes != null && notes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            notes!.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: tokens.textMuted,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],

                      // Baris 4: Deadline & Progress Subtugas
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: [
                            if (deadlineLabel != null) ...[
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: tokens.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                deadlineLabel!,
                                style: AppTheme.monoStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: tokens.textMuted,
                                ),
                              ),
                            ],
                            if (totalSubtasks > 0) ...[
                              const Spacer(),
                              SizedBox(
                                width: 90,
                                child: SegmentedProgressBar(
                                  total: totalSubtasks,
                                  completed: completedSubtasks,
                                  height: 6,
                                  showLabel: false,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$completedSubtasks/$totalSubtasks',
                                style: AppTheme.monoStyle(
                                  fontSize: 11,
                                  color: tokens.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
