import 'task_status.dart';

/// Model domain murni untuk Tugas.
class Task {
  final int id;
  final String title;
  final String? notes;
  final int subjectId;
  final DateTime dueAt;
  final TaskStatus status;
  final bool isDone;
  final DateTime? doneAt;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.notes,
    required this.subjectId,
    required this.dueAt,
    this.status = TaskStatus.todo,
    required this.isDone,
    this.doneAt,
    required this.createdAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? notes,
    int? subjectId,
    DateTime? dueAt,
    TaskStatus? status,
    bool? isDone,
    DateTime? doneAt,
    DateTime? createdAt,
  }) {
    final newStatus = status ?? this.status;
    final newIsDone = isDone ?? (status != null ? status == TaskStatus.done : this.isDone);
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      subjectId: subjectId ?? this.subjectId,
      dueAt: dueAt ?? this.dueAt,
      status: newStatus,
      isDone: newIsDone,
      doneAt: doneAt ?? this.doneAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          notes == other.notes &&
          subjectId == other.subjectId &&
          dueAt == other.dueAt &&
          status == other.status &&
          isDone == other.isDone &&
          doneAt == other.doneAt &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      notes.hashCode ^
      subjectId.hashCode ^
      dueAt.hashCode ^
      status.hashCode ^
      isDone.hashCode ^
      doneAt.hashCode ^
      createdAt.hashCode;
}
