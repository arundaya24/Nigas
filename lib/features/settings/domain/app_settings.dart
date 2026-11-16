import 'package:flutter/material.dart';

/// Kunci dan model domain untuk Pengaturan Aplikasi.
class AppSettingsKeys {
  AppSettingsKeys._();

  static const String selectedMajor = 'selected_major';
  static const String themeMode = 'theme_mode';
  static const String reminderD1Hour = 'reminder_d1_hour';
  static const String reminderD1Minute = 'reminder_d1_minute';
  static const String reminderD0Hour = 'reminder_d0_hour';
  static const String reminderD0Minute = 'reminder_d0_minute';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
}

/// Nilai bawaan jam pengingat
class ReminderTimeDefaults {
  ReminderTimeDefaults._();

  static const int d1Hour = 18; // Default H-1 jam 18:00
  static const int d1Minute = 0;
  static const int d0Hour = 7; // Default Hari-H jam 07:00
  static const int d0Minute = 0;
}

/// Objek data pengaturan aplikasi
class AppSettingsData {
  final String? selectedMajor;
  final ThemeMode themeMode;
  final TimeOfDay reminderD1;
  final TimeOfDay reminderD0;
  final bool hasCompletedOnboarding;

  const AppSettingsData({
    this.selectedMajor,
    this.themeMode = ThemeMode.system,
    this.reminderD1 = const TimeOfDay(
      hour: ReminderTimeDefaults.d1Hour,
      minute: ReminderTimeDefaults.d1Minute,
    ),
    this.reminderD0 = const TimeOfDay(
      hour: ReminderTimeDefaults.d0Hour,
      minute: ReminderTimeDefaults.d0Minute,
    ),
    this.hasCompletedOnboarding = false,
  });

  AppSettingsData copyWith({
    String? selectedMajor,
    ThemeMode? themeMode,
    TimeOfDay? reminderD1,
    TimeOfDay? reminderD0,
    bool? hasCompletedOnboarding,
  }) {
    return AppSettingsData(
      selectedMajor: selectedMajor ?? this.selectedMajor,
      themeMode: themeMode ?? this.themeMode,
      reminderD1: reminderD1 ?? this.reminderD1,
      reminderD0: reminderD0 ?? this.reminderD0,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

