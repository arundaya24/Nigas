import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/constants/app_strings.dart';
import 'package:nigas/core/db/app_database.dart';
import 'package:nigas/core/db/database_providers.dart';
import 'package:nigas/core/theme/app_theme.dart';
import 'package:nigas/core/widgets/neo_brutal_checkbox.dart';
import 'package:nigas/core/widgets/neo_brutal_chip.dart';
import 'package:nigas/features/subjects/data/subject_repository_impl.dart';
import 'package:nigas/features/tasks/data/task_repository_impl.dart';
import 'package:nigas/features/tasks/domain/task_status.dart';
import 'package:nigas/features/tasks/presentation/home_screen.dart';

void main() {
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

  Widget createHomeScreen() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initTemplatesProvider.overrideWith((ref) async {}),
      ],
      child: MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
    );
  }

  testWidgets('HomeScreen displays SMK majors (RPL, TKJ, DKV) and Mapel Umum', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createHomeScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi keberadaan kartu 3 jurusan SMK
    expect(find.text('RPL'), findsOneWidget);
    expect(find.text('TKJ'), findsOneWidget);
    expect(find.text('DKV'), findsOneWidget);

    // Verifikasi keberadaan menu Mata Pelajaran Umum
    expect(find.text('Mata Pelajaran Umum'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('HomeScreen displays tasks in To-Do list and filters by status', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final mtkId = await subjectRepo.createSubject(
      name: 'Matematika',
      colorIndex: 0,
      category: 'general',
    );
    final rplId = await subjectRepo.createSubject(
      name: 'Pemrograman Web',
      colorIndex: 2,
      category: 'rpl',
    );

    final now = DateTime.now();
    await taskRepo.createTask(
      title: 'Tugas MTK Matriks',
      subjectId: mtkId,
      dueAt: now.add(const Duration(hours: 2)),
      status: TaskStatus.todo,
    );
    await taskRepo.createTask(
      title: 'Projek Web Laravel',
      subjectId: rplId,
      dueAt: now.add(const Duration(days: 1)),
      status: TaskStatus.inProgress,
    );

    await tester.pumpWidget(createHomeScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verifikasi kedua tugas tampil di To-Do list
    expect(find.text('Tugas MTK Matriks'), findsOneWidget);
    expect(find.text('Projek Web Laravel'), findsOneWidget);

    // Filter status: tap 'Belum Dikerjakan'
    await tester.tap(find.widgetWithText(NeoBrutalChip, 'Belum Dikerjakan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Hanya tugas todo yang tampil
    expect(find.text('Tugas MTK Matriks'), findsOneWidget);
    expect(find.text('Projek Web Laravel'), findsNothing);

    // Filter status: tap 'Sedang Dikerjakan'
    await tester.tap(find.widgetWithText(NeoBrutalChip, 'Sedang Dikerjakan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Hanya tugas inProgress yang tampil
    expect(find.text('Tugas MTK Matriks'), findsNothing);
    expect(find.text('Projek Web Laravel'), findsOneWidget);

    // Kembalikan ke 'Semua Status'
    await tester.tap(find.widgetWithText(NeoBrutalChip, 'Semua Status'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tugas MTK Matriks'), findsOneWidget);
    expect(find.text('Projek Web Laravel'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Tap checkbox marks task done with Undo snackbar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final subId = await subjectRepo.createSubject(
      name: 'Bahasa Indonesia',
      colorIndex: 4,
      category: 'general',
    );
    await taskRepo.createTask(
      title: 'Tugas Teks Eksplanasi',
      subjectId: subId,
      dueAt: DateTime.now().add(const Duration(hours: 3)),
      status: TaskStatus.todo,
    );

    await tester.pumpWidget(createHomeScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tugas Teks Eksplanasi'), findsOneWidget);

    // Tap checkbox untuk menandai tugas selesai
    await tester.tap(find.byType(NeoBrutalCheckbox).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // SnackBar konfirmasi muncul
    expect(find.text(AppStrings.taskMarkedDone), findsOneWidget);
    expect(find.text('URUNGKAN'), findsOneWidget);

    // Tap URUNGKAN pada SnackBar
    await tester.tap(find.text('URUNGKAN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tugas tetap ada
    expect(find.text('Tugas Teks Eksplanasi'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('HomeScreen live search filters tasks properly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final subId = await subjectRepo.createSubject(
      name: 'Pemrograman Web',
      colorIndex: 0,
      category: 'rpl',
    );
    await taskRepo.createTask(
      title: 'Tugas Belajar Vue.js',
      subjectId: subId,
      dueAt: DateTime.now().add(const Duration(days: 2)),
    );
    await taskRepo.createTask(
      title: 'Praktikum Routing Cisco',
      subjectId: subId,
      dueAt: DateTime.now().add(const Duration(days: 3)),
    );

    await tester.pumpWidget(createHomeScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tugas Belajar Vue.js'), findsOneWidget);
    expect(find.text('Praktikum Routing Cisco'), findsOneWidget);

    // Cari 'Vue'
    await tester.enterText(find.byType(TextField).first, 'Vue');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tugas Belajar Vue.js'), findsOneWidget);
    expect(find.text('Praktikum Routing Cisco'), findsNothing);

    // Cari kata yang tidak ada
    await tester.enterText(find.byType(TextField).first, 'Mikrotik');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tugas Belajar Vue.js'), findsNothing);
    expect(find.text('Praktikum Routing Cisco'), findsNothing);
    expect(find.text('Tidak ada hasil'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
