/// Model domain murni untuk Subtugas / Langkah Pengerjaan.
class Subtask {
  final int id;
  final int taskId;
  final String title;
  final bool isDone;
  final int sortOrder;

  const Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
    required this.sortOrder,
  });

  Subtask copyWith({
    int? id,
    int? taskId,
    String? title,
    bool? isDone,
    int? sortOrder,
  }) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subtask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskId == other.taskId &&
          title == other.title &&
          isDone == other.isDone &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      id.hashCode ^
      taskId.hashCode ^
      title.hashCode ^
      isDone.hashCode ^
      sortOrder.hashCode;
}

