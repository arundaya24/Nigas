import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/db/app_database.dart';
import 'package:nigas/features/onboarding/domain/vocational_major.dart';
import 'package:nigas/features/settings/data/settings_repository_impl.dart';
import 'package:nigas/features/subjects/data/subject_repository_impl.dart';
import 'package:nigas/features/tasks/data/task_repository_impl.dart';

void main() {
  late AppDatabase db;
  late SubjectRepositoryImpl subjectRepo;
  late TaskRepositoryImpl taskRepo;
  late SettingsRepositoryImpl settingsRepo;

  setUp(() {
    // Inisialisasi Drift in-memory database murni untuk pengujian
    db = AppDatabase(NativeDatabase.memory());
    subjectRepo = SubjectRepositoryImpl(db);
    taskRepo = TaskRepositoryImpl(db);
    settingsRepo = SettingsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SubjectRepository Tests', () {
    test('Seed general and vocational subjects for TKJ', () async {
      await subjectRepo.seedSubjects(kGeneralSubjects);
      final tkjMajor =
          kVocationalMajors.firstWhere((m) => m.code == 'TKJ');
      await subjectRepo.seedSubjects(tkjMajor.vocationalSubjects);

      final subjects = await subjectRepo.getAllSubjects();
      // 11 mapel umum + 6 mapel kejuruan TKJ = 17 mapel
      expect(subjects.length, equals(17));

      // Verifikasi nama mapel tersimpan
      final names = subjects.map((s) => s.name).toList();
      expect(names, contains('MTK'));
      expect(names, contains('ASJ'));
    });

    test('Create, update, and delete custom subject', () async {
      final id = await subjectRepo.createSubject(
        name: 'Kewirausahaan',
        colorIndex: 3,
        isPreset: false,
      );
      expect(id, isPositive);

      var subject = await subjectRepo.getSubjectById(id);
      expect(subject, isNotNull);
      expect(subject!.name, 'Kewirausahaan');
      expect(subject.colorIndex, 3);
      expect(subject.isPreset, isFalse);

      // Update
      await subjectRepo.updateSubject(
        subject.copyWith(name: 'PKWU Kreatif', colorIndex: 5),
      );
      subject = await subjectRepo.getSubjectById(id);
      expect(subject!.name, 'PKWU Kreatif');
      expect(subject.colorIndex, 5);

      // Delete
      await subjectRepo.deleteSubject(id);
      final deleted = await subjectRepo.getSubjectById(id);
      expect(deleted, isNull);
    });
  });

  group('TaskRepository Tests', () {
    late int subjectId1;
    late int subjectId2;

    setUp(() async {
      subjectId1 = await subjectRepo.createSubject(
        name: 'Matematika',
        colorIndex: 0,
      );
      subjectId2 = await subjectRepo.createSubject(
        name: 'Basis Data',
        colorIndex: 2,
      );
    });

    test('Create task with subtasks and retrieve details', () async {
      final dueAt = DateTime.now().add(const Duration(days: 1));
      final taskId = await taskRepo.createTask(
        title: 'Tugas ERD dan Normalisasi',
        subjectId: subjectId2,
        dueAt: dueAt,
        notes: 'Gunakan crow foot notation',
        subtasks: [
          'Tentukan entitas',
          'Tentukan relasi',
          'Buat 1NF, 2NF, 3NF',
        ],
      );

      final taskWithDetails = await taskRepo.getTaskById(taskId);
      expect(taskWithDetails, isNotNull);
      expect(taskWithDetails!.task.title, 'Tugas ERD dan Normalisasi');
      expect(taskWithDetails.subject.name, 'Basis Data');
      expect(taskWithDetails.subtasks.length, 3);
      expect(taskWithDetails.subtasks[0].title, 'Tentukan entitas');
      expect(taskWithDetails.subtasks[0].isDone, isFalse);
      expect(taskWithDetails.totalSubtasks, 3);
      expect(taskWithDetails.completedSubtasks, 0);
    });

    test('Update task preserves isDone status of existing subtasks', () async {
      final taskId = await taskRepo.createTask(
        title: 'Tugas Jaringan',
        subjectId: subjectId1,
        dueAt: DateTime.now().add(const Duration(days: 3)),
        subtasks: ['Krimp kabel UTP', 'Pasang Switch', 'Setting IP'],
      );

      final created = await taskRepo.getTaskById(taskId);
      final subtask1 = created!.subtasks[0];
      // Tandai subtask 1 selesai
      await taskRepo.toggleSubtaskDone(subtask1.id, true);

      // Edit task: ubah judul dan tambah subtask baru
      await taskRepo.updateTask(
        id: taskId,
        title: 'Tugas Jaringan V2',
        subjectId: subjectId1,
        dueAt: DateTime.now().add(const Duration(days: 4)),
        newSubtaskTitles: ['Krimp kabel UTP', 'Pasang Switch', 'Setting IP', 'Testing Ping'],
      );

      final updated = await taskRepo.getTaskById(taskId);
      expect(updated!.task.title, 'Tugas Jaringan V2');
      expect(updated.subtasks.length, 4);
      // Status 'Krimp kabel UTP' harus tetap isDone = true
      expect(updated.subtasks[0].isDone, isTrue);
      // Subtugas lain tetap isDone = false
      expect(updated.subtasks[1].isDone, isFalse);
      expect(updated.subtasks[2].isDone, isFalse);
      expect(updated.subtasks[3].isDone, isFalse);
    });

    test('Toggle task done sets doneAt and updates stream', () async {
      final taskId = await taskRepo.createTask(
        title: 'Latihan Matriks',
        subjectId: subjectId1,
        dueAt: DateTime.now().add(const Duration(days: 2)),
      );

      // Tandai selesai
      await taskRepo.toggleTaskDone(taskId, true);
      var taskWithDetails = await taskRepo.getTaskById(taskId);
      expect(taskWithDetails!.task.isDone, isTrue);
      expect(taskWithDetails.task.doneAt, isNotNull);

      // Kembalikan ke belum selesai
      await taskRepo.toggleTaskDone(taskId, false);
      taskWithDetails = await taskRepo.getTaskById(taskId);
      expect(taskWithDetails!.task.isDone, isFalse);
      expect(taskWithDetails.task.doneAt, isNull);
    });

    test('Filter tasks by subjectId', () async {
      await taskRepo.createTask(
        title: 'Tugas MTK 1',
        subjectId: subjectId1,
        dueAt: DateTime.now(),
      );
      await taskRepo.createTask(
        title: 'Tugas MTK 2',
        subjectId: subjectId1,
        dueAt: DateTime.now(),
      );
      await taskRepo.createTask(
        title: 'Tugas Basis Data 1',
        subjectId: subjectId2,
        dueAt: DateTime.now(),
      );

      // Watch MTK tasks only
      final mtkTasks =
          await taskRepo.watchTasks(isDone: false, subjectId: subjectId1).first;
      expect(mtkTasks.length, 2);

      // Watch Basis Data tasks only
      final bdTasks =
          await taskRepo.watchTasks(isDone: false, subjectId: subjectId2).first;
      expect(bdTasks.length, 1);

      // Watch All tasks
      final allTasks = await taskRepo.watchTasks(isDone: false).first;
      expect(allTasks.length, 3);
    });

    test('Cascade delete: deleting task deletes all its subtasks', () async {
      final taskId = await taskRepo.createTask(
        title: 'Tugas Proyek',
        subjectId: subjectId1,
        dueAt: DateTime.now(),
        subtasks: ['Sub 1', 'Sub 2', 'Sub 3'],
      );

      // Pastikan subtugas ada di database
      final beforeDelete = await db.select(db.subtasks).get();
      expect(beforeDelete.length, 3);

      // Hapus task
      await taskRepo.deleteTask(taskId);

      // Pastikan task terhapus
      final task = await taskRepo.getTaskById(taskId);
      expect(task, isNull);

      // Pastikan cascade delete menghapus subtugas secara otomatis
      final afterDelete = await db.select(db.subtasks).get();
      expect(afterDelete, isEmpty);
    });

    test('Move tasks between subjects when deleting subject', () async {
      await taskRepo.createTask(
        title: 'Tugas 1',
        subjectId: subjectId1,
        dueAt: DateTime.now(),
      );

      // Hitung tugas di mapel 1
      var count = await subjectRepo.countTasksBySubject(subjectId1);
      expect(count, 1);

      // Pindahkan tugas dari subjectId1 ke subjectId2
      await subjectRepo.moveTasksToSubject(
        fromSubjectId: subjectId1,
        toSubjectId: subjectId2,
      );

      count = await subjectRepo.countTasksBySubject(subjectId1);
      expect(count, 0);

      final count2 = await subjectRepo.countTasksBySubject(subjectId2);
      expect(count2, 1);
    });
  });

  group('SettingsRepository Tests', () {
    test('Default settings and complete onboarding', () async {
      var settings = await settingsRepo.getSettings();
      expect(settings.hasCompletedOnboarding, isFalse);
      expect(settings.selectedMajor, isNull);
      expect(settings.notificationsEnabled, isTrue);

      // Selesaikan onboarding untuk RPL
      await settingsRepo.completeOnboarding('RPL');
      settings = await settingsRepo.getSettings();

      expect(settings.hasCompletedOnboarding, isTrue);
      expect(settings.selectedMajor, 'RPL');
      expect(await settingsRepo.hasCompletedOnboarding(), isTrue);
    });

    test('Toggle notificationsEnabled setting', () async {
      await settingsRepo.saveNotificationsEnabled(false);
      var settings = await settingsRepo.getSettings();
      expect(settings.notificationsEnabled, isFalse);

      await settingsRepo.saveNotificationsEnabled(true);
      settings = await settingsRepo.getSettings();
      expect(settings.notificationsEnabled, isTrue);
    });

    test('clearCompletedTasks deletes only completed tasks and subtasks', () async {
      final subId = await subjectRepo.createSubject(name: 'Sejarah', colorIndex: 1);
      final now = DateTime.now();

      await taskRepo.createTask(
        title: 'Tugas Belum Selesai',
        subjectId: subId,
        dueAt: now.add(const Duration(days: 1)),
        subtasks: ['Langkah 1'],
      );

      final task2Id = await taskRepo.createTask(
        title: 'Tugas Selesai',
        subjectId: subId,
        dueAt: now.add(const Duration(days: 1)),
        subtasks: ['Langkah Selesai'],
      );
      await taskRepo.toggleTaskDone(task2Id, true);

      final clearedCount = await settingsRepo.clearCompletedTasks();
      expect(clearedCount, 1);

      final allTasks = await db.select(db.tasks).get();
      expect(allTasks.length, 1);
      expect(allTasks.first.title, 'Tugas Belum Selesai');
    });

    test('resetAllData clears tasks and restores default SMK templates', () async {
      final subId = await subjectRepo.createSubject(name: 'Kustom', colorIndex: 2);
      await taskRepo.createTask(
        title: 'Tugas Uji Coba',
        subjectId: subId,
        dueAt: DateTime.now(),
      );

      await settingsRepo.resetAllData();

      final remainingTasks = await db.select(db.tasks).get();
      expect(remainingTasks, isEmpty);

      final remainingSubtasks = await db.select(db.subtasks).get();
      expect(remainingSubtasks, isEmpty);

      final subjects = await db.select(db.subjects).get();
      // Seluruh template bawaan dipulihkan
      expect(subjects.isNotEmpty, isTrue);
      expect(subjects.any((s) => s.name == 'MTK'), isTrue);
      expect(subjects.any((s) => s.name == 'PAD'), isTrue);
    });
  });
}

