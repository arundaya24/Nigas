import 'package:flutter/material.dart';
import 'app_settings.dart';

/// Kontrak Repository untuk Pengaturan Aplikasi & Status Onboarding.
abstract class SettingsRepository {
  Future<AppSettingsData> getSettings();
  Stream<AppSettingsData> watchSettings();
  Future<void> saveThemeMode(ThemeMode mode);
  Future<void> saveNotificationsEnabled(bool enabled);
  Future<void> saveReminderD1(TimeOfDay time);
  Future<void> saveReminderD0(TimeOfDay time);
  Future<void> saveSelectedMajor(String majorCode);
  Future<void> completeOnboarding(String majorCode);
  Future<bool> hasCompletedOnboarding();
  Future<int> clearCompletedTasks();
  Future<void> resetAllData();
}

