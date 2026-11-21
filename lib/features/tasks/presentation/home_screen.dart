import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../../../core/widgets/neo_brutal_empty_state.dart';
import '../../../core/widgets/neo_brutal_task_card.dart';
import '../../reminders/notification_service.dart';
import '../../subjects/domain/smk_category.dart';
import '../domain/deadline_grouper.dart';
import '../domain/task_status.dart';
import '../domain/task_with_details.dart';
import 'tasks_providers.dart';
import 'widgets/general_subjects_card.dart';
import 'widgets/major_card.dart';
import 'widgets/stats_summary_card.dart';
import 'widgets/status_selector_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleToggleDone(
    BuildContext context,
    WidgetRef ref,
    TaskWithDetails item,
    bool nextDone,
  ) {
    final taskRepo = ref.read(taskRepositoryProvider);
    taskRepo.toggleTaskDone(item.task.id, nextDone);

    try {
      if (nextDone) {
        NotificationService.instance.cancelTaskReminders(item.task.id);
      } else {
        ref.read(settingsRepositoryProvider).getSettings().then((settings) {
          NotificationService.instance.scheduleTaskReminders(
            task: item.task.copyWith(isDone: false, status: TaskStatus.todo),
            subjectName: item.subject.name,
            settings: settings,
          );
        });
      }
    } catch (_) {}

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextDone ? AppStrings.taskMarkedDone : AppStrings.taskMarkedUndone,
        ),
        action: SnackBarAction(
          label: AppStrings.undo.toUpperCase(),
          textColor: AppColors.primary,
          onPressed: () {
            taskRepo.toggleTaskDone(item.task.id, !nextDone);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;

    // Pastikan template default telah diinisialisasi
    ref.watch(initTemplatesProvider);

    final stats = ref.watch(taskStatsProvider);
    final allTasksAsync = ref.watch(allTasksStreamProvider);
    final selectedStatus = ref.watch(selectedStatusFilterProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);

    // Hitung tugas aktif per jurusan
    final rplCount = ref.watch(categoryActiveCountProvider('rpl'));
    final tkjCount = ref.watch(categoryActiveCountProvider('tkj'));
    final dkvCount = ref.watch(categoryActiveCountProvider('dkv'));
    final generalCount = ref.watch(categoryActiveCountProvider('general'));

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Nigas',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Tugas SMK',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: tokens.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: allTasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (allTasks) {
          // Filter tugas untuk to-do list (status & search)
          var tasksList = allTasks;
          if (selectedStatus != null) {
            tasksList = tasksList
                .where((t) => t.task.status == selectedStatus)
                .toList();
          }

          if (_searchQuery.trim().isNotEmpty) {
            final q = _searchQuery.trim().toLowerCase();
            tasksList = tasksList.where((t) {
              final inTitle = t.task.title.toLowerCase().contains(q);
              final inSubject = t.subject.name.toLowerCase().contains(q);
              final inNotes = t.task.notes?.toLowerCase().contains(q) ?? false;
              return inTitle || inSubject || inNotes;
            }).toList();
          }

          return CustomScrollView(
            slivers: [
              // 1. Sapaan & Banner Ringkasan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Tugas',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: tokens.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola tugas kejuruan dan mata pelajaran umum.',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: tokens.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ringkasan Status
                      StatsSummaryCard(
                        stats: stats,
                        selectedStatus: selectedStatus,
                        onSelectStatus: (status) {
                          ref.read(selectedStatusFilterProvider.notifier).state =
                              status;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Bagian Jurusan SMK (RPL, TKJ, DKV)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 18,
                            color: tokens.primaryAccent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'JURUSAN',
                            style: AppTheme.monoStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Kartu RPL
                      MajorCard(
                        category: SmkCategory.rpl,
                        activeTaskCount: rplCount,
                        onTap: () => context.push('/category/rpl'),
                      ),

                      // Kartu TKJ
                      MajorCard(
                        category: SmkCategory.tkj,
                        activeTaskCount: tkjCount,
                        onTap: () => context.push('/category/tkj'),
                      ),

                      // Kartu DKV
                      MajorCard(
                        category: SmkCategory.dkv,
                        activeTaskCount: dkvCount,
                        onTap: () => context.push('/category/dkv'),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bagian Mata Pelajaran Umum
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 18,
                            color: AppColors.generalPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'MATA PELAJARAN UMUM',
                            style: AppTheme.monoStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Kartu Mapel Umum
                      GeneralSubjectsCard(
                        activeTaskCount: generalCount,
                        onTap: () => context.push('/category/general'),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Bagian To-Do List (Semua Tugas)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.checklist_rounded,
                            size: 19,
                            color: tokens.primaryAccent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SEMUA TUGAS',
                            style: AppTheme.monoStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${tasksList.length} tugas',
                            style: AppTheme.monoStyle(
                              fontSize: 12,
                              color: tokens.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: tokens.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: tokens.borderColor,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() => _searchQuery = val);
                          },
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 13.5,
                            color: tokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            hintText: 'Cari tugas, mapel, atau catatan...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: tokens.textMuted,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: tokens.textMuted,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded,
                                        size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Filter Status Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            NeoBrutalChip(
                              label: 'Semua Status',
                              isSelected: selectedStatus == null,
                              onTap: () {
                                ref
                                    .read(selectedStatusFilterProvider.notifier)
                                    .state = null;
                              },
                            ),
                            const SizedBox(width: 8),
                            NeoBrutalChip(
                              label: 'Belum Dikerjakan',
                              isSelected: selectedStatus == TaskStatus.todo,
                              activeColor: AppColors.statusTodo,
                              onTap: () {
                                ref
                                    .read(selectedStatusFilterProvider.notifier)
                                    .state = TaskStatus.todo;
                              },
                            ),
                            const SizedBox(width: 8),
                            NeoBrutalChip(
                              label: 'Sedang Dikerjakan',
                              isSelected:
                                  selectedStatus == TaskStatus.inProgress,
                              activeColor: AppColors.statusProgress,
                              onTap: () {
                                ref
                                    .read(selectedStatusFilterProvider.notifier)
                                    .state = TaskStatus.inProgress;
                              },
                            ),
                            const SizedBox(width: 8),
                            NeoBrutalChip(
                              label: 'Sudah Selesai',
                              isSelected: selectedStatus == TaskStatus.done,
                              activeColor: AppColors.statusDone,
                              onTap: () {
                                ref
                                    .read(selectedStatusFilterProvider.notifier)
                                    .state = TaskStatus.done;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // List of Tasks
              if (tasksList.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: NeoBrutalEmptyState(
                      title: _searchQuery.isNotEmpty
                          ? 'Tidak ada hasil'
                          : 'Tidak ada tugas',
                      message: _searchQuery.isNotEmpty
                          ? 'Tidak ditemukan tugas yang cocok dengan "$_searchQuery".'
                          : selectedStatus != null
                              ? 'Tidak ada tugas dengan status tersebut.'
                              : 'Belum ada tugas yang dicatat. Ketuk tombol Tambah Tugas untuk mulai membuat to-do list.',
                      actionLabel: _searchQuery.isNotEmpty
                          ? 'Hapus Pencarian'
                          : 'Tambah Tugas',
                      onAction: () {
                        if (_searchQuery.isNotEmpty) {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        } else {
                          context.push('/tasks/add');
                        }
                      },
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = tasksList[index];
                        final t = item.task;
                        final sub = item.subject;
                        final subtasks = item.subtasks;
                        final completedCount =
                            subtasks.where((s) => s.isDone).length;
                        final deadlineLabel =
                            DeadlineGrouper.getStickerText(t.dueAt, t.isDone);

                        final cat = sub.smkCategory;

                        return NeoBrutalTaskCard(
                          title: t.title,
                          subjectName: sub.name,
                          subjectColor: cat.primaryColor,
                          categoryLabel: cat.shortName,
                          categoryColor: cat.primaryColor,
                          status: t.status,
                          isDone: t.isDone,
                          deadlineLabel: deadlineLabel,
                          notes: t.notes,
                          totalSubtasks: subtasks.length,
                          completedSubtasks: completedCount,
                          onTap: () => context.push('/tasks/detail/${t.id}'),
                          onToggleDone: (val) {
                            _handleToggleDone(context, ref, item, val);
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
                      childCount: tasksList.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
