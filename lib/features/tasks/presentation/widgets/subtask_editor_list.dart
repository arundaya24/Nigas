import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';
import '../../../../core/widgets/neo_brutal_button.dart';
import '../../../../core/widgets/neo_brutal_text_field.dart';

/// Editor daftar subtugas untuk form tambah/edit tugas.
class SubtaskEditorList extends StatefulWidget {
  final List<String> initialSubtasks;
  final ValueChanged<List<String>>? onSubtasksChanged;
  final ValueChanged<List<String>>? onChanged;

  const SubtaskEditorList({
    super.key,
    required this.initialSubtasks,
    this.onSubtasksChanged,
    this.onChanged,
  });

  @override
  State<SubtaskEditorList> createState() => _SubtaskEditorListState();
}

class _SubtaskEditorListState extends State<SubtaskEditorList> {
  List<String> _subtasks = [];
  final TextEditingController _inputController = TextEditingController();
  String? _subtaskError;

  @override
  void initState() {
    super.initState();
    _subtasks = List.from(widget.initialSubtasks);
  }

  @override
  void didUpdateWidget(covariant SubtaskEditorList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.initialSubtasks, oldWidget.initialSubtasks)) {
      setState(() {
        _subtasks = List.from(widget.initialSubtasks);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onSubtasksChanged?.call(_subtasks);
    widget.onChanged?.call(_subtasks);
  }

  void _handleAddSubtask() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      setState(() => _subtaskError = AppStrings.errorSubtaskEmpty);
      return;
    }

    setState(() {
      _subtasks.add(text);
      _inputController.clear();
      _subtaskError = null;
    });
    _notifyChanged();
  }

  void _handleRemoveSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
    _notifyChanged();
  }

  void _handleMove(int from, int to) {
    if (to < 0 || to >= _subtasks.length) return;
    setState(() {
      final item = _subtasks.removeAt(from);
      _subtasks.insert(to, item);
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.neoBrutal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.taskSubtasks,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: tokens.textPrimary,
              ),
            ),
            if (_subtasks.isNotEmpty)
              Text(
                '${_subtasks.length} langkah',
                style: AppTheme.monoStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: tokens.textMuted,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Daftar Subtugas yang sudah ditambahkan
        if (_subtasks.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subtasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: tokens.cardBg,
                  borderRadius: BorderRadius.circular(tokens.borderRadius),
                  border: Border.all(color: tokens.borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    // Nomor Urut (Space Mono)
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tokens.primaryAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: tokens.borderColor, width: 1),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: AppTheme.monoStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Judul Subtugas
                    Expanded(
                      child: Text(
                        _subtasks[index],
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),

                    // Tombol Naik / Turun
                    if (index > 0)
                      GestureDetector(
                        onTap: () => _handleMove(index, index - 1),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 16,
                          color: tokens.textMuted,
                        ),
                      ),
                    if (index < _subtasks.length - 1)
                      GestureDetector(
                        onTap: () => _handleMove(index, index + 1),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: tokens.textMuted,
                          ),
                        ),
                      ),

                    const SizedBox(width: 6),

                    // Tombol Hapus Subtugas
                    GestureDetector(
                      onTap: () => _handleRemoveSubtask(index),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        if (_subtasks.isNotEmpty) const SizedBox(height: 8),

        // Input Tambah Subtugas Baru
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NeoBrutalTextField(
                controller: _inputController,
                hintText: AppStrings.subtaskHint,
                errorText: _subtaskError,
                onChanged: (_) {
                  if (_subtaskError != null) {
                    setState(() => _subtaskError = null);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            NeoBrutalButton(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              text: 'TAMBAH',
              icon: const Icon(Icons.add, size: 16),
              variant: NeoBrutalButtonVariant.secondary,
              onPressed: _handleAddSubtask,
            ),
          ],
        ),
      ],
    );
  }
}
