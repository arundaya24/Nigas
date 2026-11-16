import 'package:flutter_test/flutter_test.dart';
import 'package:nigas/core/constants/app_strings.dart';
import 'package:nigas/features/tasks/domain/task_form_validator.dart';

void main() {
  group('TaskFormValidator Unit Tests', () {
    final now = DateTime(2026, 11, 10, 8, 0, 0);

    test('Title validation: null or empty fails, valid text passes', () {
      expect(TaskFormValidator.validateTitle(null),
          equals(AppStrings.errorTitleRequired));
      expect(TaskFormValidator.validateTitle(''),
          equals(AppStrings.errorTitleRequired));
      expect(TaskFormValidator.validateTitle('   '),
          equals(AppStrings.errorTitleRequired));
      expect(TaskFormValidator.validateTitle('Laporan Praktikum TKJ'), isNull);
    });

    test('Subject validation: null or <= 0 fails, valid id passes', () {
      expect(TaskFormValidator.validateSubject(null),
          equals(AppStrings.errorSubjectRequired));
      expect(TaskFormValidator.validateSubject(0),
          equals(AppStrings.errorSubjectRequired));
      expect(TaskFormValidator.validateSubject(-1),
          equals(AppStrings.errorSubjectRequired));
      expect(TaskFormValidator.validateSubject(1), isNull);
    });

    test('Deadline validation: past time rejected for new task', () {
      final pastTime = now.subtract(const Duration(minutes: 5));
      expect(
        TaskFormValidator.validateDeadline(pastTime, now: now, isNewTask: true),
        equals(AppStrings.errorDeadlinePast),
      );

      final futureTime = now.add(const Duration(hours: 1));
      expect(
        TaskFormValidator.validateDeadline(futureTime, now: now, isNewTask: true),
        isNull,
      );

      // Pada edit tugas lama (`isNewTask: false`), deadline di masa lalu tidak ditolak
      expect(
        TaskFormValidator.validateDeadline(pastTime, now: now, isNewTask: false),
        isNull,
      );
    });

    test('Default deadline: tomorrow at 07:00 AM', () {
      final defaultDue = TaskFormValidator.defaultDeadline(now: now);
      expect(defaultDue.year, 2026);
      expect(defaultDue.month, 11);
      expect(defaultDue.day, 11);
      expect(defaultDue.hour, 7);
      expect(defaultDue.minute, 0);
    });

    test('Subtask title validation', () {
      expect(TaskFormValidator.validateSubtaskTitle(null),
          equals(AppStrings.errorSubtaskEmpty));
      expect(TaskFormValidator.validateSubtaskTitle('   '),
          equals(AppStrings.errorSubtaskEmpty));
      expect(TaskFormValidator.validateSubtaskTitle('Install Debian'), isNull);
    });
  });
}

