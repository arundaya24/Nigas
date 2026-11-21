import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/db/app_database.dart';
import 'package:nigas/core/db/database_providers.dart';
import 'package:nigas/core/theme/app_theme.dart';
import 'package:nigas/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen displays majors and completes setup',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => testDb.close());

    bool wasCompleted = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: OnboardingScreen(
            onCompleted: () {
              wasCompleted = true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan judul onboarding tampil
    expect(find.text('Pilih Jurusan SMK Kamu'), findsOneWidget);
    expect(find.text('TKJ'), findsOneWidget);
    expect(find.text('RPL'), findsOneWidget);

    // Pilih RPL
    await tester.tap(find.text('RPL'));
    await tester.pumpAndSettle();

    // Tap tombol Mulai
    final startBtn = find.text('Mulai Menggunakan Nigas');
    expect(startBtn, findsOneWidget);
    await tester.tap(startBtn);
    await tester.pumpAndSettle();

    // Verifikasi callback selesai terpanggil
    expect(wasCompleted, isTrue);

    // Verifikasi database telah diisi preset mapel umum + kejuruan RPL
    final subjects = await testDb.select(testDb.subjects).get();
    // 11 umum + 5 kejuruan RPL = 16 mapel
    expect(subjects.length, 16);
    expect(
      subjects.any((s) => s.name == 'PWEB'),
      isTrue,
    );
  });
}

