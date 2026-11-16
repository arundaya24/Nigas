import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/db/database_providers.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/reminders/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await NotificationService.instance.initialize();

  runApp(const ProviderScope(child: NigasApp()));
}

class NigasApp extends ConsumerWidget {
  const NigasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(initTemplatesProvider);

    final router = ref.watch(appRouterProvider);
    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final currentThemeMode =
        settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'Nigas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      routerConfig: router,
    );
  }
}
