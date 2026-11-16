import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase _db;

  SettingsRepositoryImpl(this._db);

  Future<String?> _getValue(String key) async {
    final query = _db.select(_db.appSettingsTable)..where((t) => t.key.equals(key));
    final entry = await query.getSingleOrNull();
    return entry?.value;
  }

  Future<void> _setValue(String key, String value) async {
    await _db.into(_db.appSettingsTable).insertOnConflictUpdate(
          AppSettingsTableCompanion.insert(
            key: key,
            value: value,
          ),
        );
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  Future<AppSettingsData> getSettings() async {
    final entries = await _db.select(_db.appSettingsTable).get();
    final map = {for (final e in entries) e.key: e.value};

    final major = map[AppSettingsKeys.selectedMajor];
    final themeMode = _parseThemeMode(map[AppSettingsKeys.themeMode]);

    final d1Hour = int.tryParse(map[AppSettingsKeys.reminderD1Hour] ?? '') ??
        ReminderTimeDefaults.d1Hour;
    final d1Minute =
        int.tryParse(map[AppSettingsKeys.reminderD1Minute] ?? '') ??
            ReminderTimeDefaults.d1Minute;

    final d0Hour = int.tryParse(map[AppSettingsKeys.reminderD0Hour] ?? '') ??
        ReminderTimeDefaults.d0Hour;
    final d0Minute =
        int.tryParse(map[AppSettingsKeys.reminderD0Minute] ?? '') ??
            ReminderTimeDefaults.d0Minute;

    final hasCompleted =
        map[AppSettingsKeys.hasCompletedOnboarding] == 'true';

    return AppSettingsData(
      selectedMajor: major,
      themeMode: themeMode,
      reminderD1: TimeOfDay(hour: d1Hour, minute: d1Minute),
      reminderD0: TimeOfDay(hour: d0Hour, minute: d0Minute),
      hasCompletedOnboarding: hasCompleted,
    );
  }

  @override
  Stream<AppSettingsData> watchSettings() {
    return _db.select(_db.appSettingsTable).watch().map((entries) {
      final map = {for (final e in entries) e.key: e.value};

      final major = map[AppSettingsKeys.selectedMajor];
      final themeMode = _parseThemeMode(map[AppSettingsKeys.themeMode]);

      final d1Hour = int.tryParse(map[AppSettingsKeys.reminderD1Hour] ?? '') ??
          ReminderTimeDefaults.d1Hour;
      final d1Minute =
          int.tryParse(map[AppSettingsKeys.reminderD1Minute] ?? '') ??
              ReminderTimeDefaults.d1Minute;

      final d0Hour = int.tryParse(map[AppSettingsKeys.reminderD0Hour] ?? '') ??
          ReminderTimeDefaults.d0Hour;
      final d0Minute =
          int.tryParse(map[AppSettingsKeys.reminderD0Minute] ?? '') ??
              ReminderTimeDefaults.d0Minute;

      final hasCompleted =
          map[AppSettingsKeys.hasCompletedOnboarding] == 'true';

      return AppSettingsData(
        selectedMajor: major,
        themeMode: themeMode,
        reminderD1: TimeOfDay(hour: d1Hour, minute: d1Minute),
        reminderD0: TimeOfDay(hour: d0Hour, minute: d0Minute),
        hasCompletedOnboarding: hasCompleted,
      );
    });
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _setValue(AppSettingsKeys.themeMode, _themeModeToString(mode));
  }

  @override
  Future<void> saveReminderD1(TimeOfDay time) async {
    await _setValue(AppSettingsKeys.reminderD1Hour, time.hour.toString());
    await _setValue(AppSettingsKeys.reminderD1Minute, time.minute.toString());
  }

  @override
  Future<void> saveReminderD0(TimeOfDay time) async {
    await _setValue(AppSettingsKeys.reminderD0Hour, time.hour.toString());
    await _setValue(AppSettingsKeys.reminderD0Minute, time.minute.toString());
  }

  @override
  Future<void> saveSelectedMajor(String majorCode) async {
    await _setValue(AppSettingsKeys.selectedMajor, majorCode);
  }

  @override
  Future<void> completeOnboarding(String majorCode) async {
    await _setValue(AppSettingsKeys.selectedMajor, majorCode);
    await _setValue(AppSettingsKeys.hasCompletedOnboarding, 'true');
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final value = await _getValue(AppSettingsKeys.hasCompletedOnboarding);
    return value == 'true';
  }
}

