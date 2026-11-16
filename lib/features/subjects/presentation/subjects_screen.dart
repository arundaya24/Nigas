import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../domain/smk_category.dart';
import '../domain/subject.dart';
import 'add_subject_dialog.dart';
import 'edit_subject_dialog.dart';

/// Halaman manajemen mata pelajaran template & kustom.
class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({super.key});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  String _selectedCategoryTab = 'rpl';

  Future<void> _handleDeleteSubject(Subject subject) async {
    final tokens = context.brutalTheme;
    final subjectRepo = ref.read(subjectRepositoryProvider);
    final taskCount = await subjectRepo.countTasksBySubject(subject.id);

    if (!mounted) return;

    if (taskCount > 0) {
      // Mapel masih memiliki tugas: Minta user memindahkan tugas
      final otherSubjects = (await subjectRepo.getAllSubjects())
          .where((s) => s.id != subject.id)
          .toList();

      if (!mounted) return;

      if (otherSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat menghapus mapel ini karena masih memiliki tugas dan tidak ada mapel lain untuk memindahkannya.',
            ),
          ),
        );
        return;
      }

      int selectedTargetId = otherSubjects.first.id;

      final shouldMove = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setDialogState) {
              return Dialog(
                backgroundColor: tokens.cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: tokens.borderColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mapel Masih Memiliki Tugas',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mapel "${subject.name}" masih memiliki $taskCount tugas. Pindahkan tugas ke mapel berikut:',
                        style: TextStyle(fontSize: 13.5, color: tokens.textMuted),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        initialValue: selectedTargetId,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        items: otherSubjects.map((s) {
                          return DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedTargetId = val);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NeoBrutalButton(
                            height: 40,
                            text: AppStrings.cancel,
                            variant: NeoBrutalButtonVariant.secondary,
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          const SizedBox(width: 8),
                          NeoBrutalButton(
                            height: 40,
                            text: 'Pindahkan & Hapus',
                            variant: NeoBrutalButtonVariant.danger,
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

      if (shouldMove == true && mounted) {
        await subjectRepo.moveTasksToSubject(
          fromSubjectId: subject.id,
          toSubjectId: selectedTargetId,
        );
        await subjectRepo.deleteSubject(subject.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tugas berhasil dipindahkan dan mapel "${subject.name}" dihapus.',
              ),
            ),
          );
        }
      }
    } else {
      // Tidak ada tugas terkait: Konfirmasi langsung
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return Dialog(
            backgroundColor: tokens.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: tokens.borderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hapus Mata Pelajaran?',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Apakah kamu yakin ingin menghapus mapel "${subject.name}"?',
                    style: TextStyle(fontSize: 13.5, color: tokens.textMuted),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NeoBrutalButton(
                        height: 40,
                        text: AppStrings.cancel,
                        variant: NeoBrutalButtonVariant.secondary,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      const SizedBox(width: 8),
                      NeoBrutalButton(
                        height: 40,
                        text: AppStrings.delete,
                        variant: NeoBrutalButtonVariant.danger,
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (confirm == true && mounted) {
        await subjectRepo.deleteSubject(subject.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mapel "${subject.name}" berhasil dihapus.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final subjectsAsync = ref.watch(subjectsStreamProvider);

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Kelola Mata Pelajaran',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Mapel Baru',
            onPressed: () async {
              await showAddSubjectDialog(
                context,
                prefilledCategory: _selectedCategoryTab,
              );
            },
          ),
        ],
      ),
      body: subjectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (allSubjects) {
          return Column(
            children: [
              // Tab Kategori (RPL, TKJ, DKV, Mapel Umum)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: SmkCategory.all.map((cat) {
                    final isSel = _selectedCategoryTab == cat.code;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () =>
                              setState(() => _selectedCategoryTab = cat.code),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? cat.primaryColor : tokens.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSel ? cat.primaryColor : tokens.borderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              cat.shortName,
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 12.5,
                                fontWeight:
                                    isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : tokens.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Daftar Mapel di kategori terpilih
              Expanded(
                child: Builder(
                  builder: (context) {
                    final filtered = allSubjects
                        .where((s) => s.category == _selectedCategoryTab)
                        .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada mata pelajaran di kategori ini.',
                          style: TextStyle(color: tokens.textMuted),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final subject = filtered[index];
                        final color =
                            AppColors.getSubjectColor(subject.colorIndex);

                        return NeoBrutalCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subject.name,
                                      style: TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: tokens.textPrimary,
                                      ),
                                    ),
                                    if (subject.isPreset) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'Template Bawaan',
                                        style: AppTheme.monoStyle(
                                          fontSize: 10.5,
                                          color: tokens.textMuted,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Edit',
                                onPressed: () {
                                  showEditSubjectDialog(context,
                                      subject: subject);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: Colors.red),
                                tooltip: 'Hapus',
                                onPressed: () => _handleDeleteSubject(subject),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showAddSubjectDialog(
            context,
            prefilledCategory: _selectedCategoryTab,
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Mapel',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

