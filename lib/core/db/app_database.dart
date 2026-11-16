import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

/// Tabel Mata Pelajaran (subjects)
@DataClassName('SubjectEntry')
class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get colorIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isPreset => boolean().withDefault(const Constant(false))();
  TextColumn get category =>
      text().withDefault(const Constant('general'))(); // 'rpl', 'tkj', 'dkv', 'general'
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Tabel Tugas (tasks)
@DataClassName('TaskEntry')
@TableIndex(name: 'tasks_subject_id_idx', columns: {#subjectId})
@TableIndex(name: 'tasks_due_at_idx', columns: {#dueAt})
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get notes => text().nullable()();
  IntColumn get subjectId => integer().customConstraint(
      'NOT NULL REFERENCES subjects(id) ON DELETE RESTRICT')();
  DateTimeColumn get dueAt => dateTime()();
  TextColumn get status =>
      text().withDefault(const Constant('todo'))(); // 'todo', 'in_progress', 'done'
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Tabel Subtugas (subtasks) dengan cascade delete saat task dihapus
@DataClassName('SubtaskEntry')
class Subtasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().customConstraint(
      'NOT NULL REFERENCES tasks(id) ON DELETE CASCADE')();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Tabel Pengaturan Aplikasi (key-value)
@DataClassName('AppSettingsEntry')
class AppSettingsTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'nigas_db',
    native: const DriftNativeOptions(
      shareAcrossIsolates: true,
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint(
            'Menggunakan ${result.chosenImplementation} karena keterbatasan fitur browser: ${result.missingFeatures}',
          );
        }
      },
    ),
  );
}

@DriftDatabase(tables: [Subjects, Tasks, Subtasks, AppSettingsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(subjects, subjects.category);
            await m.addColumn(tasks, tasks.status);
          }
        },
        beforeOpen: (details) async {
          // Aktifkan foreign key enforcement di SQLite
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
