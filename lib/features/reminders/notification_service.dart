import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../settings/domain/app_settings.dart';
import '../tasks/domain/task.dart';
import 'reminder_calculator.dart';

/// Service tunggal untuk mengelola notifikasi lokal dan izin di Android/iOS.
class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  void Function(int taskId)? _onNotificationTapped;

  /// Inisialisasi plugin notifikasi dan timezone perangkat
  Future<void> initialize({
    void Function(int taskId)? onNotificationTapped,
  }) async {
    if (_isInitialized) return;

    _onNotificationTapped = onNotificationTapped;

    // Di platform Web, notifikasi lokal native tidak didukung, inisialisasi aman lalu keluar
    if (kIsWeb) {
      tz.initializeTimeZones();
      _isInitialized = true;
      return;
    }

    // 1. Inisialisasi database timezone
    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Gagal mendapatkan local timezone, menggunakan UTC: $e');
    }

    // 2. Konfigurasi inisialisasi Android & iOS
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          final taskId = int.tryParse(payload);
          if (taskId != null) {
            _onNotificationTapped?.call(taskId);
          }
        }
      },
    );

    _isInitialized = true;
  }

  /// Memeriksa dan meminta izin notifikasi (POST_NOTIFICATIONS di Android 13+)
  Future<bool> requestPermissions(BuildContext? context) async {
    // Di Web atau platform non-mobile, lewati dengan aman
    if (kIsWeb) return false;

    final status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.notification.request();
    if (result.isGranted) {
      return true;
    }

    // Jika ditolak permanen dan context tersedia, tawarkan membuka pengaturan sistem
    if (result.isPermanentlyDenied && context != null && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Izin Notifikasi Dibutuhkan'),
          content: const Text(
            'Nigas membutuhkan izin notifikasi agar dapat mengingatkan deadline tugasmu tepat waktu. Buka Pengaturan untuk mengaktifkannya.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Nanti Saja'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                openAppSettings();
              },
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      );
    }

    return false;
  }

  /// Menjadwalkan pengingat H-1 dan Hari-H untuk sebuah tugas
  Future<void> scheduleTaskReminders({
    required Task task,
    required String subjectName,
    required AppSettingsData settings,
  }) async {
    if (kIsWeb || !_isInitialized || !settings.notificationsEnabled) return;

    // Hitung jadwal notifikasi via fungsi murni ReminderCalculator
    final schedules = ReminderCalculator.calculateReminders(
      dueAt: task.dueAt,
      reminderD1: settings.reminderD1,
      reminderD0: settings.reminderD0,
      now: DateTime.now(),
    );

    const androidDetails = AndroidNotificationDetails(
      'nigas_task_reminders',
      'Pengingat Tugas SMK',
      channelDescription: 'Notifikasi pengingat deadline tugas H-1 dan Hari-H',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // ID Notifikasi: H-1 = taskId * 2, Hari-H = taskId * 2 + 1
    final d1Id = task.id * 2;
    final d0Id = task.id * 2 + 1;

    // Batalkan jadwal lama jika ada
    await _plugin.cancel(d1Id);
    await _plugin.cancel(d0Id);

    // Jadwalkan H-1 jika belum lewat
    if (schedules.d1DateTime != null) {
      try {
        await _plugin.zonedSchedule(
          d1Id,
          'Pengingat Besok: ${task.title}',
          'Tugas mapel $subjectName memiliki deadline besok!',
          tz.TZDateTime.from(schedules.d1DateTime!, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: task.id.toString(),
        );
      } catch (e) {
        // Fallback ke inexact jika exact alarm tidak diizinkan di perangkat
        try {
          await _plugin.zonedSchedule(
            d1Id,
            'Pengingat Besok: ${task.title}',
            'Tugas mapel $subjectName memiliki deadline besok!',
            tz.TZDateTime.from(schedules.d1DateTime!, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexact,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: task.id.toString(),
          );
        } catch (_) {}
        debugPrint('Gagal menjadwalkan notifikasi H-1: $e');
      }
    }

    // Jadwalkan Hari-H jika belum lewat
    if (schedules.d0DateTime != null) {
      try {
        await _plugin.zonedSchedule(
          d0Id,
          'Hari Ini Deadline: ${task.title}',
          'Jangan lupa selesaikan dan kumpulkan tugas $subjectName hari ini!',
          tz.TZDateTime.from(schedules.d0DateTime!, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: task.id.toString(),
        );
      } catch (e) {
        // Fallback ke inexact jika exact alarm tidak diizinkan di perangkat
        try {
          await _plugin.zonedSchedule(
            d0Id,
            'Hari Ini Deadline: ${task.title}',
            'Jangan lupa selesaikan dan kumpulkan tugas $subjectName hari ini!',
            tz.TZDateTime.from(schedules.d0DateTime!, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexact,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: task.id.toString(),
          );
        } catch (_) {}
        debugPrint('Gagal menjadwalkan notifikasi Hari-H: $e');
      }
    }
  }

  /// Membatalkan seluruh notifikasi pengingat untuk tugas tertentu
  Future<void> cancelTaskReminders(int taskId) async {
    if (kIsWeb || !_isInitialized) return;
    try {
      await _plugin.cancel(taskId * 2);
      await _plugin.cancel(taskId * 2 + 1);
    } catch (e) {
      debugPrint('Gagal membatalkan pengingat tugas: $e');
    }
  }

  /// Membatalkan semua notifikasi di aplikasi
  Future<void> cancelAllReminders() async {
    if (kIsWeb || !_isInitialized) return;
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Gagal membatalkan semua pengingat: $e');
    }
  }
}

