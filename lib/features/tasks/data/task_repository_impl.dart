import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../subjects/domain/subject.dart';
import '../domain/subtask.dart';
import '../domain/task.dart';
import '../domain/task_repository.dart';
import '../domain/task_status.dart';
import '../domain/task_with_details.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase _db;

  TaskRepositoryImpl(this._db);

  Task _taskToDomain(TaskEntry entry) {
    return Task(
      id: entry.id,
      title: entry.title,
      notes: entry.notes,
      subjectId: entry.subjectId,
      dueAt: entry.dueAt,
      status: TaskStatus.fromCode(entry.status, isDoneFallback: entry.isDone),
      isDone: entry.isDone,
      doneAt: entry.doneAt,
      createdAt: entry.createdAt,
    );
  }

  Subject _subjectToDomain(SubjectEntry entry) {
    return Subject(
      id: entry.id,
      name: entry.name,
      colorIndex: entry.colorIndex,
      isPreset: entry.isPreset,
      category: entry.category,
      createdAt: entry.createdAt,
    );
  }

  Subtask _subtaskToDomain(SubtaskEntry entry) {
    return Subtask(
      id: entry.id,
      taskId: entry.taskId,
      title: entry.title,
      isDone: entry.isDone,
      sortOrder: entry.sortOrder,
    );
  }

  @override
  Stream<List<TaskWithDetails>> watchTasks({
    bool? isDone,
    TaskStatus? status,
    String? category,
    int? subjectId,
  }) {
    final query = _db.select(_db.tasks).join([
      innerJoin(_db.subjects, _db.subjects.id.equalsExp(_db.tasks.subjectId)),
    ]);

    if (isDone != null) {
      query.where(_db.tasks.isDone.equals(isDone));
    }
    if (status != null) {
      query.where(_db.tasks.status.equals(status.code));
    }
    if (category != null && category.isNotEmpty) {
      query.where(_db.subjects.category.equals(category));
    }
    if (subjectId != null) {
      query.where(_db.tasks.subjectId.equals(subjectId));
    }

    query.orderBy([
      OrderingTerm(expression: _db.tasks.dueAt, mode: OrderingMode.asc),
    ]);

    return query.watch().asyncMap((rows) async {
      if (rows.isEmpty) return <TaskWithDetails>[];

      final taskIds = rows.map((r) => r.readTable(_db.tasks).id).toList();

      final subtaskEntries = await (_db.select(_db.subtasks)
            ..where((s) => s.taskId.isIn(taskIds))
            ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]))
          .get();

      final subtasksByTaskId = <int, List<Subtask>>{};
      for (final s in subtaskEntries) {
        subtasksByTaskId.putIfAbsent(s.taskId, () => []).add(_subtaskToDomain(s));
      }

      return rows.map((r) {
        final taskEntry = r.readTable(_db.tasks);
        final subjectEntry = r.readTable(_db.subjects);
        return TaskWithDetails(
          task: _taskToDomain(taskEntry),
          subject: _subjectToDomain(subjectEntry),
          subtasks: subtasksByTaskId[taskEntry.id] ?? const [],
        );
      }).toList();
    });
  }

  @override
  Future<TaskWithDetails?> getTaskById(int id) async {
    final query = _db.select(_db.tasks).join([
      innerJoin(_db.subjects, _db.subjects.id.equalsExp(_db.tasks.subjectId)),
    ])..where(_db.tasks.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final taskEntry = row.readTable(_db.tasks);
    final subjectEntry = row.readTable(_db.subjects);

    final subtasks = await (_db.select(_db.subtasks)
          ..where((s) => s.taskId.equals(id))
          ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]))
        .get();

    return TaskWithDetails(
      task: _taskToDomain(taskEntry),
      subject: _subjectToDomain(subjectEntry),
      subtasks: subtasks.map(_subtaskToDomain).toList(),
    );
  }

  @override
  Future<int> createTask({
    required String title,
    required int subjectId,
    required DateTime dueAt,
    TaskStatus status = TaskStatus.todo,
    String? notes,
    List<String> subtasks = const [],
  }) async {
    return _db.transaction(() async {
      final taskId = await _db.into(_db.tasks).insert(
            TasksCompanion.insert(
              title: title,
              subjectId: subjectId,
              dueAt: dueAt,
              status: Value(status.code),
              isDone: Value(status == TaskStatus.done),
              doneAt: Value(status == TaskStatus.done ? DateTime.now() : null),
              notes: Value(notes),
            ),
          );

      if (subtasks.isNotEmpty) {
        for (int i = 0; i < subtasks.length; i++) {
          final trimmed = subtasks[i].trim();
          if (trimmed.isNotEmpty) {
            await _db.into(_db.subtasks).insert(
                  SubtasksCompanion.insert(
                    taskId: taskId,
                    title: trimmed,
                    sortOrder: Value(i),
                  ),
                );
          }
        }
      }

      return taskId;
    });
  }

  @override
  Future<void> updateTask({
    required int id,
    required String title,
    required int subjectId,
    required DateTime dueAt,
    TaskStatus? status,
    String? notes,
    List<String>? newSubtaskTitles,
  }) async {
    await _db.transaction(() async {
      final companion = TasksCompanion(
        title: Value(title),
        subjectId: Value(subjectId),
        dueAt: Value(dueAt),
        notes: Value(notes),
        status: status != null ? Value(status.code) : const Value.absent(),
        isDone: status != null ? Value(status == TaskStatus.done) : const Value.absent(),
        doneAt: status != null
            ? Value(status == TaskStatus.done ? DateTime.now() : null)
            : const Value.absent(),
      );

      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(companion);

      if (newSubtaskTitles != null) {
        final existingSubtasks = await (_db.select(_db.subtasks)
              ..where((s) => s.taskId.equals(id)))
            .get();
        final doneStatusMap = <String, bool>{
          for (final s in existingSubtasks)
            s.title.toLowerCase().trim(): s.isDone,
        };

        await (_db.delete(_db.subtasks)..where((s) => s.taskId.equals(id))).go();
        for (int i = 0; i < newSubtaskTitles.length; i++) {
          final trimmed = newSubtaskTitles[i].trim();
          if (trimmed.isNotEmpty) {
            final wasDone = doneStatusMap[trimmed.toLowerCase()] ?? false;
            await _db.into(_db.subtasks).insert(
                  SubtasksCompanion.insert(
                    taskId: id,
                    title: trimmed,
                    isDone: Value(wasDone),
                    sortOrder: Value(i),
                  ),
                );
          }
        }
      }
    });
  }

  @override
  Future<void> updateTaskStatus(int taskId, TaskStatus status) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        status: Value(status.code),
        isDone: Value(status == TaskStatus.done),
        doneAt: Value(status == TaskStatus.done ? DateTime.now() : null),
      ),
    );
  }

  @override
  Future<void> toggleTaskDone(int taskId, bool isDone) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        isDone: Value(isDone),
        status: Value(isDone ? TaskStatus.done.code : TaskStatus.todo.code),
        doneAt: Value(isDone ? DateTime.now() : null),
      ),
    );
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(taskId))).go();
  }

  @override
  Future<int> addSubtask({
    required int taskId,
    required String title,
  }) async {
    return _db.into(_db.subtasks).insert(
          SubtasksCompanion.insert(
            taskId: taskId,
            title: title.trim(),
          ),
        );
  }

  @override
  Future<void> toggleSubtaskDone(int subtaskId, bool isDone) async {
    await (_db.update(_db.subtasks)..where((s) => s.id.equals(subtaskId))).write(
      SubtasksCompanion(
        isDone: Value(isDone),
      ),
    );
  }

  @override
  Future<void> deleteSubtask(int subtaskId) async {
    await (_db.delete(_db.subtasks)..where((s) => s.id.equals(subtaskId))).go();
  }

  @override
  Future<void> reorderSubtasks(int taskId, List<Subtask> orderedSubtasks) async {
    await _db.batch((batch) {
      for (int i = 0; i < orderedSubtasks.length; i++) {
        batch.update(
          _db.subtasks,
          SubtasksCompanion(sortOrder: Value(i)),
          where: (t) => t.id.equals(orderedSubtasks[i].id),
        );
      }
    });
  }
}
