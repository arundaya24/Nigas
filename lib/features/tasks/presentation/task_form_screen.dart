import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../../../core/widgets/neo_brutal_text_field.dart';
import '../../reminders/notification_service.dart';
import '../../subjects/domain/smk_category.dart';
import '../../subjects/presentation/add_subject_dialog.dart';
import '../domain/task_form_validator.dart';
import '../domain/task_status.dart';
import 'widgets/subtask_editor_list.dart';
import 'widgets/task_deadline_picker.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final int? taskId;
  final String? initialCategory;
  final int? initialSubjectId;

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.initialCategory,
    this.initialSubjectId,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late String _selectedCategory;
  int? _selectedSubjectId;
  late DateTime _selectedDueAt;
  TaskStatus _selectedStatus = TaskStatus.todo;
  List<String> _subtasks = [];

  String? _titleError;
  String? _subjectError;
  String? _deadlineError;
  bool _isLoading = false;
  bool _isInit = false;

  bool get isEditMode => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'general';
    _selectedSubjectId = widget.initialSubjectId;
    _selectedDueAt = TaskFormValidator.defaultDeadline();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit && isEditMode) {
      _loadTaskData();
      _isInit = true;
    }
  }

  Future<void> _loadTaskData() async {
    setState(() => _isLoading = true);
    final repo = ref.read(taskRepositoryProvider);
    final item = await repo.getTaskById(widget.taskId!);
    if (item != null && mounted) {
      setState(() {
        _titleController.text = item.task.title;
        _notesController.text = item.task.notes ?? '';
        _selectedSubjectId = item.task.subjectId;
        _selectedCategory = item.subject.category;
        _selectedDueAt = item.task.dueAt;
        _selectedStatus = item.task.status;
        _subtasks = item.subtasks.map((s) => s.title).toList();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final titleErr = TaskFormValidator.validateTitle(title);
    final subjectErr = TaskFormValidator.validateSubject(_selectedSubjectId);
    final deadlineErr = TaskFormValidator.validateDeadline(
      _selectedDueAt,
      isNewTask: !isEditMode,
    );

    setState(() {
      _titleError = titleErr;
      _subjectError = subjectErr;
      _deadlineError = deadlineErr;
    });

    if (titleErr != null || subjectErr != null || deadlineErr != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(taskRepositoryProvider);
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      int finalTaskId;
      if (isEditMode) {
        finalTaskId = widget.taskId!;
        await repo.updateTask(
          id: finalTaskId,
          title: title,
          subjectId: _selectedSubjectId!,
          dueAt: _selectedDueAt,
          status: _selectedStatus,
          notes: notes,
          newSubtaskTitles: _subtasks,
        );
      } else {
        finalTaskId = await repo.createTask(
          title: title,
          subjectId: _selectedSubjectId!,
          dueAt: _selectedDueAt,
          status: _selectedStatus,
          notes: notes,
          subtasks: _subtasks,
        );
      }

      // Jadwalkan atau batalkan notifikasi sesuai status
      try {
        final settings = await ref.read(settingsRepositoryProvider).getSettings();
        final subject = await ref.read(subjectRepositoryProvider).getSubjectById(_selectedSubjectId!);
        final savedTask = await repo.getTaskById(finalTaskId);
        if (savedTask != null && subject != null) {
          if (_selectedStatus != TaskStatus.done) {
            await NotificationService.instance.scheduleTaskReminders(
              task: savedTask.task,
              subjectName: subject.name,
              settings: settings,
            );
          } else {
            await NotificationService.instance.cancelTaskReminders(finalTaskId);
          }
        }
      } catch (e) {
        debugPrint('Notifikasi schedule error (diabaikan): $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode ? AppStrings.taskUpdated : AppStrings.taskCreated,
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan tugas: $e')),
        );
      }
    }
  }

  Future<void> _addNewSubjectInline() async {
    final newSubjectId = await showAddSubjectDialog(
      context,
      prefilledCategory: _selectedCategory,
    );
    if (newSubjectId != null && mounted) {
      setState(() {
        _selectedSubjectId = newSubjectId;
        _subjectError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final subjectsAsync =
        ref.watch(categorySubjectsStreamProvider(_selectedCategory));

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: Text(
          isEditMode ? AppStrings.editTask : AppStrings.addTask,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: tokens.textPrimary,
          ),
        ),
      ),
      body: _isLoading && isEditMode
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Pilih Kategori Jurusan / Umum
                Text(
                  'Kategori Jurusan / Mapel',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SmkCategory.all.map((c) {
                      final isSel = _selectedCategory == c.code;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: NeoBrutalChip(
                          label: c.shortName,
                          isSelected: isSel,
                          activeColor: c.primaryColor,
                          leading: Icon(
                            c.icon,
                            size: 15,
                            color: isSel ? Colors.white : tokens.textMuted,
                          ),
                          onTap: () {
                            setState(() {
                              _selectedCategory = c.code;
                              _selectedSubjectId = null;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Judul Tugas (Wajib)
                NeoBrutalTextField(
                  controller: _titleController,
                  label: '${AppStrings.taskTitle} *',
                  hintText: 'Misal: Kerjakan modul halaman 45',
                  errorText: _titleError,
                  onChanged: (_) {
                    if (_titleError != null) {
                      setState(() => _titleError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 3. Dropdown Mata Pelajaran
                Text(
                  '${AppStrings.taskSubject} *',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                subjectsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, _) => Text('Gagal memuat mapel: $err'),
                  data: (subjects) {
                    final validSelectedId = subjects
                            .any((s) => s.id == _selectedSubjectId)
                        ? _selectedSubjectId
                        : null;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: tokens.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _subjectError != null
                              ? Theme.of(context).colorScheme.error
                              : tokens.borderColor,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: validSelectedId,
                          isExpanded: true,
                          hint: Text(
                            AppStrings.selectSubjectHint,
                            style: TextStyle(
                              fontSize: 14,
                              color: tokens.textMuted,
                            ),
                          ),
                          items: [
                            ...subjects.map((s) {
                              return DropdownMenuItem<int>(
                                value: s.id,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColors.getSubjectColor(
                                            s.colorIndex),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        s.name,
                                        style: TextStyle(
                                          fontFamily: 'SpaceGrotesk',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: tokens.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const DropdownMenuItem<int>(
                              value: -1,
                              child: Row(
                                children: [
                                  Icon(Icons.add_circle_outline,
                                      size: 18, color: AppColors.primary),
                                  SizedBox(width: 8),
                                  Text(
                                    '+ Tambah Mata Pelajaran Baru',
                                    style: TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val == -1) {
                              _addNewSubjectInline();
                            } else {
                              setState(() {
                                _selectedSubjectId = val;
                                _subjectError = null;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (_subjectError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _subjectError!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // 4. Status Pengerjaan (To-Do List)
                Text(
                  'Status Pengerjaan',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: TaskStatus.values.map((status) {
                    final isSel = _selectedStatus == status;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: InkWell(
                          onTap: () => setState(() => _selectedStatus = status),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel
                                  ? status.backgroundColor
                                  : tokens.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSel ? status.color : tokens.borderColor,
                                width: isSel ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  status.icon,
                                  size: 15,
                                  color: isSel ? status.color : tokens.textMuted,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  status.shortLabel,
                                  style: AppTheme.monoStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSel
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color:
                                        isSel ? status.color : tokens.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // 5. Deadline Waktu (Wajib)
                Text(
                  '${AppStrings.taskDeadline} *',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TaskDeadlinePicker(
                  initialDateTime: _selectedDueAt,
                  onChanged: (newDt) {
                    setState(() {
                      _selectedDueAt = newDt;
                      _deadlineError = null;
                    });
                  },
                ),
                if (_deadlineError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _deadlineError!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // 6. Catatan Tambahan (Opsional)
                NeoBrutalTextField(
                  controller: _notesController,
                  label: AppStrings.taskNotes,
                  hintText: 'Misal: Kumpul di meja guru ruang 3',
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // 7. Subtugas Checklist (Opsional)
                SubtaskEditorList(
                  initialSubtasks: _subtasks,
                  onChanged: (updated) {
                    _subtasks = updated;
                  },
                ),
                const SizedBox(height: 32),

                // 8. Tombol Simpan
                NeoBrutalButton(
                  height: 48,
                  text: _isLoading
                      ? 'Menyimpan...'
                      : (isEditMode ? AppStrings.saveChanges : AppStrings.saveTask),
                  variant: NeoBrutalButtonVariant.primary,
                  onPressed: _isLoading ? null : _handleSave,
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
