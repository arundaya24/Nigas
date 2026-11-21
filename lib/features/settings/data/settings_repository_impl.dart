import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../../subjects/domain/smk_category.dart';
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

  AppSettingsData _mapToSettings(Map<String, String> map) {
    final major = map[AppSettingsKeys.selectedMajor];
    final themeMode = _parseThemeMode(map[AppSettingsKeys.themeMode]);
    final notifEnabled = map[AppSettingsKeys.notificationsEnabled] != 'false';

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
      notificationsEnabled: notifEnabled,
      reminderD1: TimeOfDay(hour: d1Hour, minute: d1Minute),
      reminderD0: TimeOfDay(hour: d0Hour, minute: d0Minute),
      hasCompletedOnboarding: hasCompleted,
    );
  }

  @override
  Future<AppSettingsData> getSettings() async {
    final entries = await _db.select(_db.appSettingsTable).get();
    final map = {for (final e in entries) e.key: e.value};
    return _mapToSettings(map);
  }

  @override
  Stream<AppSettingsData> watchSettings() {
    return _db.select(_db.appSettingsTable).watch().map((entries) {
      final map = {for (final e in entries) e.key: e.value};
      return _mapToSettings(map);
    });
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _setValue(AppSettingsKeys.themeMode, _themeModeToString(mode));
  }

  @override
  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _setValue(AppSettingsKeys.notificationsEnabled, enabled.toString());
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

  @override
  Future<int> clearCompletedTasks() async {
    final completedTasks = await (_db.select(_db.tasks)
          ..where((t) => t.isDone.equals(true) | t.status.equals('done')))
        .get();

    final count = completedTasks.length;
    if (count == 0) return 0;

    final taskIds = completedTasks.map((t) => t.id).toList();

    await _db.transaction(() async {
      await (_db.delete(_db.subtasks)..where((s) => s.taskId.isIn(taskIds))).go();
      await (_db.delete(_db.tasks)..where((t) => t.id.isIn(taskIds))).go();
    });

    return count;
  }

  @override
  Future<void> resetAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.subtasks).go();
      await _db.delete(_db.tasks).go();
      await _db.delete(_db.subjects).go();
      await _db.delete(_db.appSettingsTable).go();
    });

    // Seed ulang seluruh template bawaan
    await _db.transaction(() async {
      for (final cat in SmkCategory.all) {
        for (int i = 0; i < cat.templateSubjects.length; i++) {
          final name = cat.templateSubjects[i];
          await _db.into(_db.subjects).insert(
                SubjectsCompanion.insert(
                  name: name,
                  category: Value(cat.code),
                  colorIndex: Value(i % 8),
                  isPreset: const Value(true),
                ),
              );
        }
      }
    });
  }
}

