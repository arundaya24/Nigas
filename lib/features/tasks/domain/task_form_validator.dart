import '../../../core/constants/app_strings.dart';

/// Validator fungsi murni untuk validasi form tugas.
class TaskFormValidator {
  TaskFormValidator._();

  /// Validasi judul tugas (wajib diisi, minimal 1 karakter non-spasi)
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorTitleRequired;
    }
    return null;
  }

  /// Validasi mata pelajaran (wajib dipilih)
  static String? validateSubject(int? subjectId) {
    if (subjectId == null || subjectId <= 0) {
      return AppStrings.errorSubjectRequired;
    }
    return null;
  }

  /// Validasi deadline:
  /// Saat membuat tugas baru (`isNewTask: true`), waktu tenggat tidak boleh sebelum waktu sekarang.
  static String? validateDeadline(
    DateTime dueAt, {
    DateTime? now,
    bool isNewTask = true,
  }) {
    if (!isNewTask) return null;

    final current = now ?? DateTime.now();
    if (dueAt.isBefore(current)) {
      return AppStrings.errorDeadlinePast;
    }
    return null;
  }

  /// Validasi teks subtugas baru
  static String? validateSubtaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorSubtaskEmpty;
    }
    return null;
  }

  /// Validasi nama mapel baru
  static String? validateSubjectName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorSubjectNameRequired;
    }
    return null;
  }

  /// Default deadline: besok pukul 07:00
  static DateTime defaultDeadline({DateTime? now}) {
    final current = now ?? DateTime.now();
    final tomorrow = current.add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7, 0, 0);
  }
}

