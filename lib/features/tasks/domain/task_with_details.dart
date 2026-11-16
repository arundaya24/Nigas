import '../../subjects/domain/subject.dart';
import 'subtask.dart';
import 'task.dart';

/// Agregat domain untuk Tugas lengkap beserta Mata Pelajaran dan Subtugasnya.
class TaskWithDetails {
  final Task task;
  final Subject subject;
  final List<Subtask> subtasks;

  const TaskWithDetails({
    required this.task,
    required this.subject,
    this.subtasks = const [],
  });

  int get totalSubtasks => subtasks.length;
  int get completedSubtasks => subtasks.where((s) => s.isDone).length;
  bool get allSubtasksDone =>
      subtasks.isNotEmpty && subtasks.every((s) => s.isDone);

  TaskWithDetails copyWith({
    Task? task,
    Subject? subject,
    List<Subtask>? subtasks,
  }) {
    return TaskWithDetails(
      task: task ?? this.task,
      subject: subject ?? this.subject,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

