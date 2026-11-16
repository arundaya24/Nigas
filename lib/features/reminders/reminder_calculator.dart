import 'package:flutter/material.dart';

/// Hasil kalkulasi jadwal notifikasi pengingat H-1 dan Hari-H
class ScheduledReminders {
  final DateTime? d1DateTime;
  final DateTime? d0DateTime;

  const ScheduledReminders({
    this.d1DateTime,
    this.d0DateTime,
  });

  bool get hasAny => d1DateTime != null || d0DateTime != null;
}

/// Fungsi murni (pure functions) untuk menghitung jadwal pengingat tugas.
/// Terisolasi dari platform untuk memudahkan unit testing.
class ReminderCalculator {
  ReminderCalculator._();

  /// Menghitung jadwal notifikasi H-1.
  /// Melewati dan mengembalikan `null` jika waktu notifikasi sudah terlewat atau setelah deadline.
  static DateTime? calculateD1Schedule({
    required DateTime dueAt,
    required TimeOfDay reminderTime,
    required DateTime now,
  }) {
    // Kurangi 1 hari dari tanggal deadline
    final targetDate = DateTime(dueAt.year, dueAt.month, dueAt.day - 1);
    final scheduled = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    // Jika waktu notifikasi sudah lewat dari 'now' atau setelah deadline, lewati
    if (scheduled.isBefore(now) || scheduled.isAfter(dueAt) || scheduled.isAtSameMomentAs(dueAt)) {
      return null;
    }

    return scheduled;
  }

  /// Menghitung jadwal notifikasi Hari-H.
  /// Melewati dan mengembalikan `null` jika waktu notifikasi sudah terlewat atau setelah deadline.
  static DateTime? calculateD0Schedule({
    required DateTime dueAt,
    required TimeOfDay reminderTime,
    required DateTime now,
  }) {
    final scheduled = DateTime(
      dueAt.year,
      dueAt.month,
      dueAt.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    // Jika waktu pengingat sudah lewat atau setelah deadline, lewati
    if (scheduled.isBefore(now) || scheduled.isAfter(dueAt) || scheduled.isAtSameMomentAs(dueAt)) {
      return null;
    }

    return scheduled;
  }

  /// Menghitung kedua jadwal notifikasi sekaligus.
  static ScheduledReminders calculateReminders({
    required DateTime dueAt,
    required TimeOfDay reminderD1,
    required TimeOfDay reminderD0,
    required DateTime now,
  }) {
    return ScheduledReminders(
      d1DateTime: calculateD1Schedule(
        dueAt: dueAt,
        reminderTime: reminderD1,
        now: now,
      ),
      d0DateTime: calculateD0Schedule(
        dueAt: dueAt,
        reminderTime: reminderD0,
        now: now,
      ),
    );
  }
}

