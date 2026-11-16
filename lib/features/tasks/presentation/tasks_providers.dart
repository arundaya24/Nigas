import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/database_providers.dart';
import '../domain/task_status.dart';
import '../domain/task_with_details.dart';

/// Stream semua tugas di aplikasi (digunakan untuk to-do list beranda & statistik)
final allTasksStreamProvider = StreamProvider<List<TaskWithDetails>>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  return taskRepo.watchTasks();
});

/// Stream tugas belum selesai (untuk tab Belum Selesai legacy & filter)
final pendingTasksProvider = StreamProvider<List<TaskWithDetails>>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  final activeSubjectId = ref.watch(selectedSubjectFilterProvider);

  return taskRepo.watchTasks(
    isDone: false,
    subjectId: activeSubjectId,
  );
});

/// Stream tugas selesai
final completedTasksProvider = StreamProvider<List<TaskWithDetails>>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  final activeSubjectId = ref.watch(selectedSubjectFilterProvider);

  return taskRepo.watchTasks(
    isDone: true,
    subjectId: activeSubjectId,
  );
});

/// Stream tugas berdasarkan kategori jurusan ('rpl', 'tkj', 'dkv', 'general')
final categoryTasksProvider =
    StreamProvider.family<List<TaskWithDetails>, String>((ref, category) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  return taskRepo.watchTasks(category: category);
});

/// Tab filter status di to-do list: null = Semua, todo, inProgress, done
final selectedStatusFilterProvider = StateProvider<TaskStatus?>((ref) => null);

/// Filter kategori aktif di beranda: null = Semua, 'rpl', 'tkj', 'dkv', 'general'
final selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

/// Filter mapel per kategori (id mapel atau null)
final categoryActiveSubjectFilterProvider =
    StateProvider.family<int?, String>((ref, category) => null);

/// Hitung jumlah tugas aktif (belum selesai) per kategori
final categoryActiveCountProvider =
    Provider.family<int, String>((ref, category) {
  final tasksAsync = ref.watch(categoryTasksProvider(category));
  final tasks = tasksAsync.valueOrNull ?? [];
  return tasks.where((t) => t.task.status != TaskStatus.done).length;
});

/// Ringkasan total status tugas
class TaskStats {
  final int total;
  final int todo;
  final int inProgress;
  final int done;

  const TaskStats({
    required this.total,
    required this.todo,
    required this.inProgress,
    required this.done,
  });
}

final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasksAsync = ref.watch(allTasksStreamProvider);
  final tasks = tasksAsync.valueOrNull ?? [];

  int todo = 0;
  int inProgress = 0;
  int done = 0;

  for (final t in tasks) {
    switch (t.task.status) {
      case TaskStatus.todo:
        todo++;
        break;
      case TaskStatus.inProgress:
        inProgress++;
        break;
      case TaskStatus.done:
        done++;
        break;
    }
  }

  return TaskStats(
    total: tasks.length,
    todo: todo,
    inProgress: inProgress,
    done: done,
  );
});

/// Tab aktif di beranda: 0 = Belum Selesai, 1 = Selesai
final homeTabProvider = StateProvider<int>((ref) => 0);
