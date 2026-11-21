import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nigas/core/constants/app_strings.dart';
import 'package:nigas/core/db/app_database.dart';
import 'package:nigas/core/db/database_providers.dart';
import 'package:nigas/core/theme/app_theme.dart';
import 'package:nigas/core/widgets/neo_brutal_checkbox.dart';
import 'package:nigas/features/subjects/data/subject_repository_impl.dart';
import 'package:nigas/features/tasks/data/task_repository_impl.dart';
import 'package:nigas/features/tasks/presentation/task_detail_screen.dart';
import 'package:nigas/features/tasks/presentation/task_form_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  late AppDatabase db;
  late SubjectRepositoryImpl subjectRepo;
  late TaskRepositoryImpl taskRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    subjectRepo = SubjectRepositoryImpl(db);
    taskRepo = TaskRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('TaskFormScreen validates fields and creates task with subtasks',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Buat mapel contoh
    final subjectId = await subjectRepo.createSubject(
      name: 'Teknik Jaringan Komputer',
      colorIndex: 2,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const TaskFormScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan tombol SIMPAN TUGAS ada
    final saveBtn = find.text(AppStrings.saveTask);
    expect(saveBtn, findsOneWidget);

    // Coba simpan tanpa mengisi judul -> Muncul pesan error
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();
    expect(find.text('Judul tugas wajib diisi'), findsOneWidget);

    // Isi judul
    await tester.enterText(
      find.byType(TextField).first,
      'Laporan Konfigurasi VLAN',
    );
    await tester.pumpAndSettle();

    // Pilih mapel dari Dropdown
    await tester.tap(find.text('Pilih Mata Pelajaran'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teknik Jaringan Komputer').last);
    await tester.pumpAndSettle();

    // Tambah subtugas
    final subtaskField = find.widgetWithText(TextField, 'Tulis langkah pengerjaan...');
    await tester.enterText(subtaskField, 'Bikin trunk port');
    await tester.tap(find.text('TAMBAH'));
    await tester.pumpAndSettle();

    expect(find.text('Bikin trunk port'), findsOneWidget);

    // Simpan tugas
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // Verifikasi di database
    final tasks = await db.select(db.tasks).get();
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Laporan Konfigurasi VLAN');
    expect(tasks.first.subjectId, subjectId);

    final subtasks = await db.select(db.subtasks).get();
    expect(subtasks.length, 1);
    expect(subtasks.first.title, 'Bikin trunk port');

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('TaskDetailScreen checks subtasks and offers task completion',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final subId = await subjectRepo.createSubject(
      name: 'Pemrograman Web',
      colorIndex: 0,
    );
    final taskId = await taskRepo.createTask(
      title: 'Proyek Toko Online',
      subjectId: subId,
      dueAt: DateTime.now().add(const Duration(days: 2)),
      notes: 'Gunakan HTML, CSS, dan JS',
      subtasks: ['Buat Navbar', 'Buat Form Checkout'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: TaskDetailScreen(taskId: taskId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi detail tampil
    expect(find.text('Proyek Toko Online'), findsOneWidget);
    expect(find.text('Pemrograman Web'), findsOneWidget);
    expect(find.text('Gunakan HTML, CSS, dan JS'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);

    // Centang subtugas 1
    await tester.tap(find.byType(NeoBrutalCheckbox).first);
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);

    // Centang subtugas 2 -> semua selesai -> Muncul dialog penawaran selesai
    await tester.tap(find.byType(NeoBrutalCheckbox).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.allSubtasksCompleted), findsOneWidget);
    expect(find.text(AppStrings.markTaskDone), findsOneWidget);

    // Tap TANDAI SELESAI
    await tester.tap(find.text(AppStrings.markTaskDone));
    await tester.pumpAndSettle();

    // Verifikasi task utama sekarang menjadi selesai
    final updated = await taskRepo.getTaskById(taskId);
    expect(updated!.task.isDone, isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}

