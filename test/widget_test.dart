import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/theme/app_theme.dart';
import 'package:nigas/core/widgets/neo_brutal_button.dart';
import 'package:nigas/core/widgets/neo_brutal_checkbox.dart';
import 'package:nigas/features/showcase/presentation/showcase_screen.dart';

void main() {
  testWidgets('ShowcaseScreen renders all Neo-Brutalism components',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var currentTheme = ThemeMode.light;

    await tester.pumpWidget(
      ProviderScope(
        child: StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: currentTheme,
              home: ShowcaseScreen(
                currentThemeMode: currentTheme,
                onToggleTheme: () {
                  setState(() {
                    currentTheme = currentTheme == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan judul showcase tampil
    expect(find.text('Design System'), findsOneWidget);
    expect(find.text('NEO-BRUTALISM SHOWCASE'), findsOneWidget);

    // Pastikan tombol-tombol ada
    expect(find.text('Primary Yellow'), findsOneWidget);
    expect(find.text('Secondary White'), findsOneWidget);
    expect(find.text('Success Lime'), findsOneWidget);
    expect(find.text('Danger Red'), findsOneWidget);

    // Pastikan sticker deadline ada
    expect(find.text('TELAT 2 HARI'), findsOneWidget);
    expect(find.text('HARI INI'), findsOneWidget);

    // Uji interaksi tombol tema
    final toggleThemeBtn = find.text('Mode Gelap');
    expect(toggleThemeBtn, findsOneWidget);
    await tester.tap(toggleThemeBtn);
    await tester.pumpAndSettle();

    // Setelah di-tap, teks beralih ke Mode Terang
    expect(find.text('Mode Terang'), findsOneWidget);
  });

  testWidgets('NeoBrutalCheckbox toggles value and animates',
      (WidgetTester tester) async {
    bool isChecked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return NeoBrutalCheckbox(
                value: isChecked,
                onChanged: (val) {
                  setState(() => isChecked = val);
                },
              );
            },
          ),
        ),
      ),
    );

    // Mulai dari uncheck
    expect(isChecked, isFalse);

    // Tap checkbox
    await tester.tap(find.byType(NeoBrutalCheckbox));
    await tester.pumpAndSettle();

    // Menjadi check
    expect(isChecked, isTrue);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('NeoBrutalButton triggers callback on tap',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NeoBrutalButton(
            text: 'Klik Saya',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Klik Saya'), findsOneWidget);
    await tester.tap(find.byType(NeoBrutalButton));
    await tester.pumpAndSettle();

    expect(wasPressed, isTrue);
  });
}
