import 'subtask.dart';
import 'task_status.dart';
import 'task_with_details.dart';

/// Kontrak Repository untuk Tugas dan Subtugas.
abstract class TaskRepository {
  Stream<List<TaskWithDetails>> watchTasks({
    bool? isDone,
    TaskStatus? status,
    String? category,
    int? subjectId,
  });

  Future<TaskWithDetails?> getTaskById(int id);

  Future<int> createTask({
    required String title,
    required int subjectId,
    required DateTime dueAt,
    TaskStatus status = TaskStatus.todo,
    String? notes,
    List<String> subtasks = const [],
  });

  Future<void> updateTask({
    required int id,
    required String title,
    required int subjectId,
    required DateTime dueAt,
    TaskStatus? status,
    String? notes,
    List<String>? newSubtaskTitles,
  });

  Future<void> updateTaskStatus(int taskId, TaskStatus status);

  Future<void> toggleTaskDone(int taskId, bool isDone);

  Future<void> deleteTask(int taskId);

  Future<int> addSubtask({
    required int taskId,
    required String title,
  });

  Future<void> toggleSubtaskDone(int subtaskId, bool isDone);

  Future<void> deleteSubtask(int subtaskId);

  Future<void> reorderSubtasks(int taskId, List<Subtask> orderedSubtasks);
}
