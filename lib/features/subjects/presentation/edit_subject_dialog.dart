import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_text_field.dart';
import '../domain/smk_category.dart';
import '../domain/subject.dart';

Future<bool?> showEditSubjectDialog(
  BuildContext context, {
  required Subject subject,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => EditSubjectDialog(subject: subject),
  );
}

/// Dialog untuk mengubah nama, kategori, dan warna mata pelajaran.
class EditSubjectDialog extends ConsumerStatefulWidget {
  final Subject subject;

  const EditSubjectDialog({
    super.key,
    required this.subject,
  });

  @override
  ConsumerState<EditSubjectDialog> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends ConsumerState<EditSubjectDialog> {
  late final TextEditingController _nameController;
  late String _category;
  late int _selectedColorIndex;
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _category = widget.subject.category;
    _selectedColorIndex = widget.subject.colorIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = AppStrings.errorSubjectNameRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final repo = ref.read(subjectRepositoryProvider);
      final updated = widget.subject.copyWith(
        name: name,
        category: _category,
        colorIndex: _selectedColorIndex,
      );
      await repo.updateSubject(updated);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorText = 'Gagal menyimpan: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;

    return Dialog(
      backgroundColor: tokens.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: tokens.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Mata Pelajaran',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Pilihan Kategori
              Text(
                'Kategori Jurusan / Umum',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: SmkCategory.all.map((c) {
                  return DropdownMenuItem(
                    value: c.code,
                    child: Text(c.fullName),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 14),

              // Input Nama Mapel
              NeoBrutalTextField(
                controller: _nameController,
                label: 'Nama Mata Pelajaran',
                errorText: _errorText,
                autofocus: true,
                onSubmitted: (_) => _handleSave(),
              ),
              const SizedBox(height: 16),

              // Palet Warna Mapel
              Text(
                'Warna Label Mapel',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.subjectPalette.length,
                  itemBuilder: (context, index) {
                    final color = AppColors.subjectPalette[index];
                    final isSelected = index == _selectedColorIndex;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Batal & Simpan
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeoBrutalButton(
                    height: 42,
                    text: AppStrings.cancel,
                    variant: NeoBrutalButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  const SizedBox(width: 8),
                  NeoBrutalButton(
                    height: 42,
                    text: _isLoading ? 'Menyimpan...' : AppStrings.save,
                    variant: NeoBrutalButtonVariant.primary,
                    onPressed: _isLoading ? null : _handleSave,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

