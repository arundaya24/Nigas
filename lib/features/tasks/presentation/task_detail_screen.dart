import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../../../core/widgets/neo_brutal_checkbox.dart';
import '../../../core/widgets/segmented_progress_bar.dart';
import '../../../core/widgets/task_status_badge.dart';
import '../../reminders/notification_service.dart';
import '../domain/deadline_grouper.dart';
import '../domain/subtask.dart';
import '../domain/task_status.dart';
import '../domain/task_with_details.dart';
import 'widgets/status_selector_bottom_sheet.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  TaskWithDetails? _item;
  bool _isLoading = true;
  bool _offeredDone = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final repo = ref.read(taskRepositoryProvider);
    final taskData = await repo.getTaskById(widget.taskId);
    if (mounted) {
      setState(() {
        _item = taskData;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleToggleSubtask(Subtask subtask, bool isDone) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.toggleSubtaskDone(subtask.id, isDone);
    await _loadTask();

    if (_item != null) {
      if (_item!.task.status != TaskStatus.done &&
          _item!.allSubtasksDone &&
          !_offeredDone &&
          mounted) {
        _offeredDone = true;
        _showAllSubtasksDoneDialog();
      } else if (!_item!.allSubtasksDone) {
        _offeredDone = false;
      }
    }
  }

  void _showAllSubtasksDoneDialog() {
    final tokens = context.brutalTheme;
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: tokens.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: tokens.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.celebration_rounded,
                        color: AppColors.accentEmerald, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppStrings.allSubtasksCompleted,
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.allSubtasksCompletedPrompt,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: tokens.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NeoBrutalButton(
                      height: 40,
                      text: AppStrings.later,
                      variant: NeoBrutalButtonVariant.secondary,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    const SizedBox(width: 8),
                    NeoBrutalButton(
                      height: 40,
                      text: AppStrings.markTaskDone,
                      variant: NeoBrutalButtonVariant.success,
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        final repo = ref.read(taskRepositoryProvider);
                        await repo.updateTaskStatus(
                            widget.taskId, TaskStatus.done);
                        try {
                          await NotificationService.instance
                              .cancelTaskReminders(widget.taskId);
                        } catch (_) {}
                        await _loadTask();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleDelete() async {
    final tokens = context.brutalTheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: tokens.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: tokens.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hapus Tugas Ini?',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tugas "${_item?.task.title}" beserta seluruh subtugasnya akan dihapus permanen.',
                  style: TextStyle(fontSize: 13.5, color: tokens.textMuted),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NeoBrutalButton(
                      height: 40,
                      text: AppStrings.cancel,
                      variant: NeoBrutalButtonVariant.secondary,
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    const SizedBox(width: 8),
                    NeoBrutalButton(
                      height: 40,
                      text: AppStrings.delete,
                      variant: NeoBrutalButtonVariant.danger,
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm == true && mounted) {
      final repo = ref.read(taskRepositoryProvider);
      await repo.deleteTask(widget.taskId);
      try {
        await NotificationService.instance.cancelTaskReminders(widget.taskId);
      } catch (_) {}
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil dihapus.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: tokens.scaffoldBg,
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_item == null) {
      return Scaffold(
        backgroundColor: tokens.scaffoldBg,
        appBar: AppBar(),
        body: const Center(child: Text('Tugas tidak ditemukan.')),
      );
    }

    final item = _item!;
    final subject = item.subject;
    final cat = subject.smkCategory;
    final dateFormat = DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID');
    final completedCount = item.subtasks.where((s) => s.isDone).length;
    final isDone = item.task.status == TaskStatus.done;

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: tokens.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.editTask,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await context.push('/tasks/edit/${item.task.id}');
              _loadTask();
            },
          ),
          IconButton(
            tooltip: AppStrings.deleteTask,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Tag Kategori & Mapel + Status Badge Interaktif
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cat.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  cat.shortName.toUpperCase(),
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cat.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.cardBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: tokens.borderColor, width: 1),
                ),
                child: Text(
                  subject.name,
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              TaskStatusBadge(
                status: item.task.status,
                onTap: () async {
                  final newStatus = await showTaskStatusPicker(
                    context,
                    currentStatus: item.task.status,
                  );
                  if (newStatus != null) {
                    final repo = ref.read(taskRepositoryProvider);
                    await repo.updateTaskStatus(item.task.id, newStatus);
                    try {
                      if (newStatus == TaskStatus.done) {
                        await NotificationService.instance
                            .cancelTaskReminders(item.task.id);
                      } else if (item.task.status == TaskStatus.done) {
                        final settings = await ref
                            .read(settingsRepositoryProvider)
                            .getSettings();
                        await NotificationService.instance.scheduleTaskReminders(
                          task: item.task.copyWith(
                            status: newStatus,
                            isDone: false,
                          ),
                          subjectName: item.subject.name,
                          settings: settings,
                        );
                      }
                    } catch (_) {}
                    await _loadTask();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Judul Tugas
          Text(
            item.task.title,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDone ? tokens.textMuted : tokens.textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),

          // 3. Kartu Informasi Deadline
          NeoBrutalCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 22,
                  color: tokens.primaryAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenggat Waktu (Deadline)',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: tokens.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateFormat.format(item.task.dueAt),
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tokens.scaffoldBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: tokens.borderColor, width: 1),
                  ),
                  child: Text(
                    DeadlineGrouper.getStickerText(item.task.dueAt, isDone),
                    style: AppTheme.monoStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Catatan Tambahan (jika ada)
          if (item.task.notes != null && item.task.notes!.trim().isNotEmpty) ...[
            NeoBrutalCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notes_rounded, size: 18, color: tokens.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        'Catatan',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.task.notes!,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: tokens.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // 5. Daftar Checklist Subtugas
          if (item.subtasks.isNotEmpty) ...[
            NeoBrutalCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Checklist Subtugas',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$completedCount/${item.subtasks.length} Selesai',
                        style: AppTheme.monoStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: tokens.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SegmentedProgressBar(
                    total: item.subtasks.length,
                    completed: completedCount,
                    height: 6,
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item.subtasks.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 14,
                      color: tokens.borderColor.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final subtask = item.subtasks[index];
                      return InkWell(
                        onTap: () =>
                            _handleToggleSubtask(subtask, !subtask.isDone),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              NeoBrutalCheckbox(
                                value: subtask.isDone,
                                onChanged: (val) =>
                                    _handleToggleSubtask(subtask, val),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  subtask.title,
                                  style: TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: subtask.isDone
                                        ? tokens.textMuted
                                        : tokens.textPrimary,
                                    decoration: subtask.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 6. Tombol Aksi Cepat: Toggle Status Selesai
          NeoBrutalButton(
            height: 48,
            variant: isDone
                ? NeoBrutalButtonVariant.secondary
                : NeoBrutalButtonVariant.success,
            icon: Icon(
              isDone ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
              size: 20,
            ),
            text: isDone ? 'Kembalikan ke Belum Selesai' : 'Tandai Tugas Selesai',
            onPressed: () async {
              final repo = ref.read(taskRepositoryProvider);
              final newStatus = isDone ? TaskStatus.todo : TaskStatus.done;
              await repo.updateTaskStatus(item.task.id, newStatus);
              try {
                if (newStatus == TaskStatus.done) {
                  await NotificationService.instance
                      .cancelTaskReminders(item.task.id);
                } else {
                  final settings = await ref
                      .read(settingsRepositoryProvider)
                      .getSettings();
                  await NotificationService.instance.scheduleTaskReminders(
                    task: item.task.copyWith(
                      status: newStatus,
                      isDone: false,
                    ),
                    subjectName: item.subject.name,
                    settings: settings,
                  );
                }
              } catch (_) {}
              await _loadTask();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
