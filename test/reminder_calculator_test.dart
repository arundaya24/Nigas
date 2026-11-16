import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/features/reminders/reminder_calculator.dart';

void main() {
  group('ReminderCalculator Unit Tests', () {
    final reminderD1 = const TimeOfDay(hour: 18, minute: 0); // 18:00 WIB
    final reminderD0 = const TimeOfDay(hour: 7, minute: 0); // 07:00 WIB

    test('H-1 schedule calculated correctly 1 day before dueAt', () {
      final now = DateTime(2026, 11, 14, 10, 0);
      final dueAt = DateTime(2026, 11, 16, 12, 0); // Deadline 16 Nov jam 12:00

      final d1 = ReminderCalculator.calculateD1Schedule(
        dueAt: dueAt,
        reminderTime: reminderD1,
        now: now,
      );

      expect(d1, isNotNull);
      expect(d1, equals(DateTime(2026, 11, 15, 18, 0)));
    });

    test('H-1 schedule returns null if already in the past', () {
      final now = DateTime(2026, 11, 15, 19, 0); // Sudah lewat jam 18:00 di 15 Nov
      final dueAt = DateTime(2026, 11, 16, 12, 0);

      final d1 = ReminderCalculator.calculateD1Schedule(
        dueAt: dueAt,
        reminderTime: reminderD1,
        now: now,
      );

      expect(d1, isNull);
    });

    test('H-1 schedule returns null if dueAt is today (H-1 was yesterday)', () {
      final now = DateTime(2026, 11, 14, 10, 0);
      final dueAt = DateTime(2026, 11, 14, 16, 0); // Deadline hari ini jam 16:00

      final d1 = ReminderCalculator.calculateD1Schedule(
        dueAt: dueAt,
        reminderTime: reminderD1,
        now: now,
      );

      expect(d1, isNull);
    });

    test('Hari-H schedule calculated correctly on deadline day', () {
      final now = DateTime(2026, 11, 14, 10, 0);
      final dueAt = DateTime(2026, 11, 16, 12, 0); // Deadline 16 Nov jam 12:00

      final d0 = ReminderCalculator.calculateD0Schedule(
        dueAt: dueAt,
        reminderTime: reminderD0,
        now: now,
      );

      expect(d0, isNotNull);
      expect(d0, equals(DateTime(2026, 11, 16, 7, 0)));
    });

    test('Hari-H schedule returns null if already in the past', () {
      final now = DateTime(2026, 11, 16, 8, 0); // Sudah jam 08:00 di hari-H
      final dueAt = DateTime(2026, 11, 16, 12, 0);

      final d0 = ReminderCalculator.calculateD0Schedule(
        dueAt: dueAt,
        reminderTime: reminderD0,
        now: now,
      );

      expect(d0, isNull);
    });

    test('calculateReminders returns both valid schedules', () {
      final now = DateTime(2026, 11, 14, 6, 0);
      final dueAt = DateTime(2026, 11, 16, 12, 0);

      final result = ReminderCalculator.calculateReminders(
        dueAt: dueAt,
        reminderD1: reminderD1,
        reminderD0: reminderD0,
        now: now,
      );

      expect(result.hasAny, isTrue);
      expect(result.d1DateTime, equals(DateTime(2026, 11, 15, 18, 0)));
      expect(result.d0DateTime, equals(DateTime(2026, 11, 16, 7, 0)));
    });
  });
}
