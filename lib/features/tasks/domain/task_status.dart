import 'package:flutter/material.dart';

/// Status pengerjaan tugas (To-Do List):
/// - [todo] : Belum Dikerjakan
/// - [inProgress] : Sedang Dikerjakan
/// - [done] : Sudah Selesai
enum TaskStatus {
  todo('todo', 'Belum Dikerjakan', 'Belum'),
  inProgress('in_progress', 'Sedang Dikerjakan', 'Sedang'),
  done('done', 'Sudah Selesai', 'Selesai');

  final String code;
  final String label;
  final String shortLabel;

  const TaskStatus(this.code, this.label, this.shortLabel);

  static TaskStatus fromCode(String? code, {bool isDoneFallback = false}) {
    if (code == 'done' || isDoneFallback) return TaskStatus.done;
    if (code == 'in_progress') return TaskStatus.inProgress;
    return TaskStatus.todo;
  }

  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return const Color(0xFFD97706); // Amber 600
      case TaskStatus.inProgress:
        return const Color(0xFF2563EB); // Blue 600
      case TaskStatus.done:
        return const Color(0xFF059669); // Emerald 600
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TaskStatus.todo:
        return const Color(0xFFFEF3C7); // Amber 100
      case TaskStatus.inProgress:
        return const Color(0xFFDBEAFE); // Blue 100
      case TaskStatus.done:
        return const Color(0xFFD1FAE5); // Emerald 100
    }
  }

  Color get borderColor {
    switch (this) {
      case TaskStatus.todo:
        return const Color(0xFFFDE68A); // Amber 200
      case TaskStatus.inProgress:
        return const Color(0xFFBFDBFE); // Blue 200
      case TaskStatus.done:
        return const Color(0xFFA7F3D0); // Emerald 200
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.todo:
        return Icons.schedule_rounded;
      case TaskStatus.inProgress:
        return Icons.timelapse_rounded;
      case TaskStatus.done:
        return Icons.check_circle_rounded;
    }
  }
}

