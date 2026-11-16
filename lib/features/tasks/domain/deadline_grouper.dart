import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/deadline_sticker.dart';
import 'task_with_details.dart';

enum DeadlineGroup {
  overdue(AppStrings.groupOverdue),
  today(AppStrings.groupToday),
  tomorrow(AppStrings.groupTomorrow),
  thisWeek(AppStrings.groupThisWeek),
  later(AppStrings.groupLater);

  final String label;
  const DeadlineGroup(this.label);
}

/// Helper fungsi murni untuk pengelompokan deadline dan perhitungan label stiker.
class DeadlineGrouper {
  DeadlineGrouper._();

  /// Mengambil tanggal murni (jam 00:00:00) untuk perbandingan batas tengah malam
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// Menentukan kelompok deadline sebuah waktu tugas berdasarkan waktu acuan (now)
  static DeadlineGroup getGroup(DateTime dueAt, {DateTime? now}) {
    final current = now ?? DateTime.now();

    // Jika waktu tenggat sudah lewat dari waktu saat ini
    if (dueAt.isBefore(current)) {
      return DeadlineGroup.overdue;
    }

    final todayMidnight = dateOnly(current);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));
    final dayAfterTomorrowMidnight = todayMidnight.add(const Duration(days: 2));

    // Akhir minggu: jika sisa hari dalam minggu kalender < 3 hari (Jumat-Minggu),
    // gunakan jendela 7 hari ke depan agar siswa tetap melihat tugas mingguannya.
    final daysToMonday = 8 - current.weekday;
    final calendarWeekEnd = todayMidnight.add(Duration(days: daysToMonday));
    final endOfWeek = calendarWeekEnd.isAfter(dayAfterTomorrowMidnight)
        ? calendarWeekEnd
        : todayMidnight.add(const Duration(days: 7));

    if (dueAt.isBefore(tomorrowMidnight)) {
      return DeadlineGroup.today;
    } else if (dueAt.isBefore(dayAfterTomorrowMidnight)) {
      return DeadlineGroup.tomorrow;
    } else if (dueAt.isBefore(endOfWeek)) {
      return DeadlineGroup.thisWeek;
    } else {
      return DeadlineGroup.later;
    }
  }

  /// Menghasilkan teks stiker tenggat waktu (Space Mono uppercase)
  static String getStickerText(DateTime dueAt, bool isDone, {DateTime? now}) {
    if (isDone) return AppStrings.stickerDone;

    final current = now ?? DateTime.now();
    final todayMidnight = dateOnly(current);
    final dueMidnight = dateOnly(dueAt);

    if (dueAt.isBefore(current)) {
      final daysLate = todayMidnight.difference(dueMidnight).inDays;
      if (daysLate >= 1) {
        return '${AppStrings.stickerOverdue} $daysLate ${AppStrings.stickerDaysLeft.replaceAll('LAGI', '').trim()}';
      }
      return AppStrings.stickerOverdue;
    }

    final group = getGroup(dueAt, now: current);
    switch (group) {
      case DeadlineGroup.overdue:
        return AppStrings.stickerOverdue;
      case DeadlineGroup.today:
        return AppStrings.stickerToday;
      case DeadlineGroup.tomorrow:
        return AppStrings.stickerTomorrow;
      case DeadlineGroup.thisWeek:
      case DeadlineGroup.later:
        final daysLeft = dueMidnight.difference(todayMidnight).inDays;
        if (daysLeft > 1) {
          return '$daysLeft ${AppStrings.stickerDaysLeft}';
        }
        return AppStrings.stickerTomorrow;
    }
  }

  /// Menentukan status visual stiker untuk pewarnaan
  static DeadlineStatus getStickerStatus(
    DateTime dueAt,
    bool isDone, {
    DateTime? now,
  }) {
    if (isDone) return DeadlineStatus.done;
    final group = getGroup(dueAt, now: now);
    switch (group) {
      case DeadlineGroup.overdue:
        return DeadlineStatus.overdue;
      case DeadlineGroup.today:
        return DeadlineStatus.today;
      case DeadlineGroup.tomorrow:
        return DeadlineStatus.tomorrow;
      case DeadlineGroup.thisWeek:
      case DeadlineGroup.later:
        return DeadlineStatus.upcoming;
    }
  }

  /// Mengelompokkan daftar tugas ke dalam `Map<DeadlineGroup, List<TaskWithDetails>>`
  /// Grup kosong tidak akan disertakan dalam hasil Map.
  static Map<DeadlineGroup, List<TaskWithDetails>> groupTasks(
    List<TaskWithDetails> tasks, {
    DateTime? now,
  }) {
    final grouped = <DeadlineGroup, List<TaskWithDetails>>{};

    for (final group in DeadlineGroup.values) {
      final matched = tasks
          .where((t) => getGroup(t.task.dueAt, now: now) == group)
          .toList();

      if (matched.isNotEmpty) {
        // Urutkan tugas dalam grup berdasarkan waktu deadline terdekat
        matched.sort((a, b) => a.task.dueAt.compareTo(b.task.dueAt));
        grouped[group] = matched;
      }
    }

    return grouped;
  }
}
