import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../../../core/widgets/neo_brutal_empty_state.dart';
import '../../../core/widgets/neo_brutal_task_card.dart';
import '../../reminders/notification_service.dart';
import '../../subjects/domain/smk_category.dart';
import '../../subjects/presentation/add_subject_dialog.dart';
import '../domain/deadline_grouper.dart';
import '../domain/task_status.dart';
import 'tasks_providers.dart';
import 'widgets/status_selector_bottom_sheet.dart';

/// Halaman daftar tugas khusus untuk jurusan (RPL, TKJ, DKV) atau Mapel Umum.
class CategoryTasksScreen extends ConsumerStatefulWidget {
  final String categoryCode;

  const CategoryTasksScreen({
    super.key,
    required this.categoryCode,
  });

  @override
  ConsumerState<CategoryTasksScreen> createState() =>
      _CategoryTasksScreenState();
}

class _CategoryTasksScreenState extends ConsumerState<CategoryTasksScreen> {
  int? _selectedSubjectId;
  TaskStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final category = SmkCategory.fromCode(widget.categoryCode);

    final subjectsAsync =
        ref.watch(categorySubjectsStreamProvider(widget.categoryCode));
    final tasksAsync = ref.watch(categoryTasksProvider(widget.categoryCode));
    final taskRepo = ref.watch(taskRepositoryProvider);

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: Text(
          category.shortName,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            color: tokens.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Mata Pelajaran',
            onPressed: () async {
              final newSubjectId = await showAddSubjectDialog(
                context,
                prefilledCategory: widget.categoryCode,
              );
              if (newSubjectId != null && mounted) {
                setState(() => _selectedSubjectId = newSubjectId);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            '/tasks/add?category=${widget.categoryCode}${_selectedSubjectId != null ? '&subjectId=$_selectedSubjectId' : ''}',
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (allTasks) {
          // Filter tugas berdasarkan subject dan status
          var filteredTasks = allTasks;
          if (_selectedSubjectId != null) {
            filteredTasks = filteredTasks
                .where((t) => t.subject.id == _selectedSubjectId)
                .toList();
          }
          if (_selectedStatus != null) {
            filteredTasks = filteredTasks
                .where((t) => t.task.status == _selectedStatus)
                .toList();
          }

          final activeCount = allTasks
              .where((t) => t.task.status != TaskStatus.done)
              .length;

          return CustomScrollView(
            slivers: [
              // Header Info Jurusan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tokens.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.borderColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: category.lightColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            category.icon,
                            color: category.primaryColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.fullName,
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: tokens.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                category.description,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: tokens.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: category.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$activeCount aktif',
                            style: AppTheme.monoStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: category.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Filter Baris Mata Pelajaran Template
              SliverToBoxAdapter(
                child: subjectsAsync.when(
                  loading: () => const SizedBox(height: 44),
                  error: (err, stack) => const SizedBox.shrink(),
                  data: (subjects) {
                    return SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          NeoBrutalChip(
                            label: 'Semua Mapel',
                            isSelected: _selectedSubjectId == null,
                            activeColor: category.primaryColor,
                            onTap: () => setState(() => _selectedSubjectId = null),
                          ),
                          const SizedBox(width: 8),
                          ...subjects.map((sub) {
                            final isSel = _selectedSubjectId == sub.id;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: NeoBrutalChip(
                                label: sub.name,
                                isSelected: isSel,
                                activeColor: category.primaryColor,
                                onTap: () => setState(() {
                                  _selectedSubjectId = isSel ? null : sub.id;
                                }),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: NeoBrutalChip(
                              label: 'Tambah Mapel',
                              leading: const Icon(Icons.add_rounded, size: 16),
                              isSelected: false,
                              onTap: () async {
                                final newSubjectId = await showAddSubjectDialog(
                                  context,
                                  prefilledCategory: widget.categoryCode,
                                );
                                if (newSubjectId != null && mounted) {
                                  setState(() => _selectedSubjectId = newSubjectId);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Filter Tab Status (Semua | Belum | Sedang | Selesai)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      _buildStatusFilterPill('Semua', null),
                      const SizedBox(width: 6),
                      _buildStatusFilterPill('Belum', TaskStatus.todo),
                      const SizedBox(width: 6),
                      _buildStatusFilterPill('Sedang', TaskStatus.inProgress),
                      const SizedBox(width: 6),
                      _buildStatusFilterPill('Selesai', TaskStatus.done),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              // Daftar Tugas
              if (filteredTasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: NeoBrutalEmptyState(
                    title: 'Tidak ada tugas',
                    message: _selectedStatus != null || _selectedSubjectId != null
                        ? 'Tidak ada tugas dengan filter ini.'
                        : 'Belum ada tugas di kategori ${category.shortName}. Klik Tambah Tugas untuk mulai mencatat.',
                    actionLabel: 'Tambah Tugas',
                    onAction: () {
                      context.push(
                        '/tasks/add?category=${widget.categoryCode}${_selectedSubjectId != null ? '&subjectId=$_selectedSubjectId' : ''}',
                      );
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final taskDetail = filteredTasks[index];
                        final t = taskDetail.task;
                        final sub = taskDetail.subject;
                        final subtasks = taskDetail.subtasks;

                        final completedSubtasksCount =
                            subtasks.where((s) => s.isDone).length;
                        final deadlineLabel =
                            DeadlineGrouper.getStickerText(t.dueAt, t.isDone);

                        return NeoBrutalTaskCard(
                          title: t.title,
                          subjectName: sub.name,
                          subjectColor: category.primaryColor,
                          status: t.status,
                          isDone: t.isDone,
                          deadlineLabel: deadlineLabel,
                          notes: t.notes,
                          totalSubtasks: subtasks.length,
                          completedSubtasks: completedSubtasksCount,
                          onTap: () {
                            context.push('/tasks/detail/${t.id}');
                          },
                          onToggleDone: (val) {
                            taskRepo.toggleTaskDone(t.id, val);
                            try {
                              if (val) {
                                NotificationService.instance.cancelTaskReminders(t.id);
                              } else {
                                ref.read(settingsRepositoryProvider).getSettings().then((settings) {
                                  NotificationService.instance.scheduleTaskReminders(
                                    task: t.copyWith(isDone: false, status: TaskStatus.todo),
                                    subjectName: sub.name,
                                    settings: settings,
                                  );
                                });
                              }
                            } catch (_) {}
                          },
                          onStatusTap: () async {
                            final newStatus = await showTaskStatusPicker(
                              context,
                              currentStatus: t.status,
                            );
                            if (newStatus != null) {
                              await taskRepo.updateTaskStatus(t.id, newStatus);
                            }
                          },
                        );
                      },
                      childCount: filteredTasks.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusFilterPill(String label, TaskStatus? status) {
    final tokens = context.brutalTheme;
    final isSelected = _selectedStatus == status;

    Color activeColor = tokens.primaryAccent;
    if (status != null) {
      activeColor = status.color;
    }

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedStatus = status),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (status != null ? status.backgroundColor : tokens.cardBg)
                : tokens.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : tokens.borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? activeColor : tokens.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

