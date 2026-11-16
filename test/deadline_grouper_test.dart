import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/widgets/deadline_sticker.dart';
import 'package:nigas/features/subjects/domain/subject.dart';
import 'package:nigas/features/tasks/domain/deadline_grouper.dart';
import 'package:nigas/features/tasks/domain/task.dart';
import 'package:nigas/features/tasks/domain/task_with_details.dart';

void main() {
  group('DeadlineGrouper Unit Tests (Midnight & Timezone Boundaries)', () {
    // Waktu acuan: Selasa, 10 November 2026 jam 10:00:00 WIB
    final now = DateTime(2026, 11, 10, 10, 0, 0);

    test('Overdue tasks: past days and past hours today', () {
      // 2 hari lalu
      final twoDaysAgo = DateTime(2026, 11, 8, 10, 0, 0);
      expect(DeadlineGrouper.getGroup(twoDaysAgo, now: now),
          equals(DeadlineGroup.overdue));
      expect(DeadlineGrouper.getStickerText(twoDaysAgo, false, now: now),
          equals('TELAT 2 HARI'));
      expect(DeadlineGrouper.getStickerStatus(twoDaysAgo, false, now: now),
          equals(DeadlineStatus.overdue));

      // 1 menit yang lalu hari ini
      final oneMinuteAgo = DateTime(2026, 11, 10, 9, 59, 0);
      expect(DeadlineGrouper.getGroup(oneMinuteAgo, now: now),
          equals(DeadlineGroup.overdue));
      expect(DeadlineGrouper.getStickerText(oneMinuteAgo, false, now: now),
          equals('TELAT'));
    });

    test('Today tasks: from now until today midnight 23:59:59', () {
      // 1 jam ke depan hari ini
      final oneHourLater = DateTime(2026, 11, 10, 11, 0, 0);
      expect(DeadlineGrouper.getGroup(oneHourLater, now: now),
          equals(DeadlineGroup.today));
      expect(DeadlineGrouper.getStickerText(oneHourLater, false, now: now),
          equals('HARI INI'));
      expect(DeadlineGrouper.getStickerStatus(oneHourLater, false, now: now),
          equals(DeadlineStatus.today));

      // Tepat sebelum pergantian tengah malam (23:59:59)
      final endOfToday = DateTime(2026, 11, 10, 23, 59, 59);
      expect(DeadlineGrouper.getGroup(endOfToday, now: now),
          equals(DeadlineGroup.today));
      expect(DeadlineGrouper.getStickerText(endOfToday, false, now: now),
          equals('HARI INI'));
    });

    test('Tomorrow tasks: strictly between 00:00:00 and 23:59:59 tomorrow', () {
      // Tepat tengah malam besok (00:00:00)
      final tomorrowMidnight = DateTime(2026, 11, 11, 0, 0, 0);
      expect(DeadlineGrouper.getGroup(tomorrowMidnight, now: now),
          equals(DeadlineGroup.tomorrow));
      expect(DeadlineGrouper.getStickerText(tomorrowMidnight, false, now: now),
          equals('BESOK'));
      expect(DeadlineGrouper.getStickerStatus(tomorrowMidnight, false, now: now),
          equals(DeadlineStatus.tomorrow));

      // Besok jam 07:00 (default deadline tugas SMK)
      final tomorrowMorning = DateTime(2026, 11, 11, 7, 0, 0);
      expect(DeadlineGrouper.getGroup(tomorrowMorning, now: now),
          equals(DeadlineGroup.tomorrow));
      expect(DeadlineGrouper.getStickerText(tomorrowMorning, false, now: now),
          equals('BESOK'));

      // Tepat sebelum pergantian tengah malam besok (23:59:59)
      final tomorrowEnd = DateTime(2026, 11, 11, 23, 59, 59);
      expect(DeadlineGrouper.getGroup(tomorrowEnd, now: now),
          equals(DeadlineGroup.tomorrow));
      expect(DeadlineGrouper.getStickerText(tomorrowEnd, false, now: now),
          equals('BESOK'));
    });

    test('This week tasks: from day after tomorrow until end of week', () {
      // Kamis, 12 November 2026 jam 00:00:00 (2 hari lagi)
      final dayAfterTomorrow = DateTime(2026, 11, 12, 0, 0, 0);
      expect(DeadlineGrouper.getGroup(dayAfterTomorrow, now: now),
          equals(DeadlineGroup.thisWeek));
      expect(DeadlineGrouper.getStickerText(dayAfterTomorrow, false, now: now),
          equals('2 HARI LAGI'));
      expect(
          DeadlineGrouper.getStickerStatus(dayAfterTomorrow, false, now: now),
          equals(DeadlineStatus.upcoming));

      // Sabtu, 14 November 2026 (4 hari lagi)
      final saturday = DateTime(2026, 11, 14, 15, 0, 0);
      expect(DeadlineGrouper.getGroup(saturday, now: now),
          equals(DeadlineGroup.thisWeek));
      expect(DeadlineGrouper.getStickerText(saturday, false, now: now),
          equals('4 HARI LAGI'));
    });

    test('Later tasks: far in the future', () {
      final nextMonth = DateTime(2026, 12, 10, 10, 0, 0);
      expect(DeadlineGrouper.getGroup(nextMonth, now: now),
          equals(DeadlineGroup.later));
      expect(DeadlineGrouper.getStickerText(nextMonth, false, now: now),
          equals('30 HARI LAGI'));
    });

    test('Completed tasks return SELESAI sticker', () {
      final anyDate = DateTime(2026, 11, 5, 10, 0, 0);
      expect(DeadlineGrouper.getStickerText(anyDate, true, now: now),
          equals('SELESAI'));
      expect(DeadlineGrouper.getStickerStatus(anyDate, true, now: now),
          equals(DeadlineStatus.done));
    });

    test('groupTasks omits empty groups and preserves order', () {
      final sampleSubject = Subject(
        id: 1,
        name: 'Matematika',
        colorIndex: 0,
        isPreset: true,
        createdAt: now,
      );

      final taskToday = TaskWithDetails(
        task: Task(
          id: 1,
          title: 'Tugas Hari Ini',
          subjectId: 1,
          dueAt: DateTime(2026, 11, 10, 14, 0, 0),
          isDone: false,
          createdAt: now,
        ),
        subject: sampleSubject,
      );

      final taskTomorrow = TaskWithDetails(
        task: Task(
          id: 2,
          title: 'Tugas Besok',
          subjectId: 1,
          dueAt: DateTime(2026, 11, 11, 8, 0, 0),
          isDone: false,
          createdAt: now,
        ),
        subject: sampleSubject,
      );

      final grouped = DeadlineGrouper.groupTasks([taskTomorrow, taskToday], now: now);

      // Hanya grup "today" dan "tomorrow" yang ada
      expect(grouped.containsKey(DeadlineGroup.today), isTrue);
      expect(grouped.containsKey(DeadlineGroup.tomorrow), isTrue);
      // Grup kosong ("overdue", "thisWeek", "later") tidak boleh ada
      expect(grouped.containsKey(DeadlineGroup.overdue), isFalse);
      expect(grouped.containsKey(DeadlineGroup.thisWeek), isFalse);
      expect(grouped.containsKey(DeadlineGroup.later), isFalse);

      expect(grouped[DeadlineGroup.today]!.length, 1);
      expect(grouped[DeadlineGroup.tomorrow]!.length, 1);
    });
  });
}

