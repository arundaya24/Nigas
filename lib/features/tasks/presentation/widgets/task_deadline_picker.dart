import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';

/// Widget pemilih tanggal dan jam deadline dengan desain modern dan bersih.
class TaskDeadlinePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final DateTime? initialDateTime;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ValueChanged<DateTime>? onChanged;
  final String? errorText;

  const TaskDeadlinePicker({
    super.key,
    this.selectedDateTime,
    this.initialDateTime,
    this.onDateTimeChanged,
    this.onChanged,
    this.errorText,
  });

  DateTime get _effectiveDateTime =>
      selectedDateTime ?? initialDateTime ?? DateTime.now();

  void _notify(DateTime dt) {
    onDateTimeChanged?.call(dt);
    onChanged?.call(dt);
  }

  Future<void> _pickDate(BuildContext context) async {
    final first = _effectiveDateTime.isBefore(DateTime(2020))
        ? _effectiveDateTime.subtract(const Duration(days: 365))
        : DateTime(2020);
    final last = _effectiveDateTime.isAfter(DateTime(2040))
        ? _effectiveDateTime.add(const Duration(days: 365))
        : DateTime(2040);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _effectiveDateTime,
      firstDate: first,
      lastDate: last,
    );

    if (pickedDate != null) {
      final newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _effectiveDateTime.hour,
        _effectiveDateTime.minute,
      );
      _notify(newDateTime);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_effectiveDateTime),
      builder: (ctx, child) {
        // Reset inputDecorationTheme agar padding dan border global
        // tidak mengganggu layout internal TimePicker text input mode.
        // Tanpa ini, contentPadding(vertical:14) + OutlineInputBorder(r:12)
        // menyebabkan BoxConstraints NOT NORMALIZED pada layar kecil.
        final theme = Theme.of(ctx);
        return Theme(
          data: theme.copyWith(
            inputDecorationTheme: const InputDecorationTheme(),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final newDateTime = DateTime(
        _effectiveDateTime.year,
        _effectiveDateTime.month,
        _effectiveDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _notify(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final dateFormat = DateFormat('EEEE, d MMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    final dateStr = dateFormat.format(_effectiveDateTime);
    final timeStr = '${timeFormat.format(_effectiveDateTime)} WIB';

    return Row(
      children: [
        // Tombol Tanggal
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () => _pickDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: tokens.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: errorText != null
                      ? Theme.of(context).colorScheme.error
                      : tokens.borderColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: AppTheme.monoStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Tombol Jam
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () => _pickTime(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: tokens.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: errorText != null
                      ? Theme.of(context).colorScheme.error
                      : tokens.borderColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      timeStr,
                      style: AppTheme.monoStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
