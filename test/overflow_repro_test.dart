import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/db/app_database.dart';
import 'package:nigas/core/db/database_providers.dart';
import 'package:nigas/core/theme/app_theme.dart';
import 'package:nigas/features/tasks/presentation/home_screen.dart';
import 'package:nigas/features/tasks/presentation/widgets/general_subjects_card.dart';

void main() {
  testWidgets('Check overflow on various screen sizes', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => db.close());

    final sizes = [
      const Size(320, 568),
      const Size(360, 640),
      const Size(360, 800),
      const Size(375, 667),
      const Size(390, 844),
      const Size(411, 731),
      const Size(412, 915),
    ];

    final scales = [1.0, 1.1, 1.15, 1.25];

    for (final size in sizes) {
      for (final scale in scales) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(db),
              initTemplatesProvider.overrideWith((ref) async {}),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: MediaQuery(
                data: MediaQueryData(
                  size: size,
                  textScaler: TextScaler.linear(scale),
                ),
                child: const HomeScreen(),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        final dynamic exception = tester.takeException();
        if (exception != null) {
          debugPrint('OVERFLOW on size $size, scale $scale: $exception');
        }
      }
    }
  });
}
