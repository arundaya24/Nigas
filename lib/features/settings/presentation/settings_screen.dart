import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../domain/app_settings.dart';

/// Halaman Pengaturan Aplikasi: Tema, Waktu Pengingat, dan Manajemen Mapel.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref, {
    required TimeOfDay initialTime,
    required Future<void> Function(TimeOfDay) onSaved,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      await onSaved(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.brutalTheme;
    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final subjectRepo = ref.read(subjectRepositoryProvider);

    final settings = settingsAsync.valueOrNull ??
        const AppSettingsData();

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Mode Tampilan (Tema)
          _buildSectionHeader('TAMPILAN', Icons.palette_outlined, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema Aplikasi',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih tema terang, gelap, atau ikuti pengaturan sistem perangkatmu.',
                  style: TextStyle(fontSize: 12.5, color: tokens.textMuted),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: NeoBrutalChip(
                        label: 'Terang',
                        isSelected: settings.themeMode == ThemeMode.light,
                        leading: const Icon(Icons.wb_sunny_outlined, size: 16),
                        onTap: () =>
                            settingsRepo.saveThemeMode(ThemeMode.light),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NeoBrutalChip(
                        label: 'Gelap',
                        isSelected: settings.themeMode == ThemeMode.dark,
                        leading: const Icon(Icons.nightlight_outlined, size: 16),
                        onTap: () =>
                            settingsRepo.saveThemeMode(ThemeMode.dark),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NeoBrutalChip(
                        label: 'Sistem',
                        isSelected: settings.themeMode == ThemeMode.system,
                        leading: const Icon(Icons.settings_system_daydream, size: 16),
                        onTap: () =>
                            settingsRepo.saveThemeMode(ThemeMode.system),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Jam Pengingat Tugas
          _buildSectionHeader('PENGINGAT & NOTIFIKASI', Icons.notifications_outlined, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // H-1
                InkWell(
                  onTap: () => _pickTime(
                    context,
                    ref,
                    initialTime: settings.reminderD1,
                    onSaved: (time) => settingsRepo.saveReminderD1(time),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.alarm, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengingat H-1 Deadline',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: tokens.textPrimary,
                                ),
                              ),
                              Text(
                                'Notifikasi sehari sebelum deadline',
                                style: TextStyle(fontSize: 12, color: tokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: tokens.scaffoldBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: tokens.borderColor, width: 1),
                          ),
                          child: Text(
                            '${settings.reminderD1.format(context)} WIB',
                            style: AppTheme.monoStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: tokens.borderColor.withValues(alpha: 0.5), height: 16),

                // Hari-H
                InkWell(
                  onTap: () => _pickTime(
                    context,
                    ref,
                    initialTime: settings.reminderD0,
                    onSaved: (time) => settingsRepo.saveReminderD0(time),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.statusTodoBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.today_rounded, color: AppColors.statusTodo, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengingat Hari-H Deadline',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: tokens.textPrimary,
                                ),
                              ),
                              Text(
                                'Notifikasi di pagi hari saat deadline tiba',
                                style: TextStyle(fontSize: 12, color: tokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: tokens.scaffoldBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: tokens.borderColor, width: 1),
                          ),
                          child: Text(
                            '${settings.reminderD0.format(context)} WIB',
                            style: AppTheme.monoStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Kelola Mapel
          _buildSectionHeader('MATA PELAJARAN', Icons.auto_stories_outlined, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => context.push('/settings/subjects'),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.generalLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_note_rounded, color: AppColors.generalPrimary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kelola Template & Mapel Kustom',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: tokens.textPrimary,
                              ),
                            ),
                            Text(
                              'Tambah, ubah nama, ganti warna, atau hapus mapel',
                              style: TextStyle(fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: tokens.textMuted),
                    ],
                  ),
                ),
                Divider(color: tokens.borderColor.withValues(alpha: 0.5), height: 16),
                InkWell(
                  onTap: () async {
                    await subjectRepo.seedDefaultTemplates();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Template mapel berhasil dipulihkan.'),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.rplLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.restore_rounded, color: AppColors.rplPrimary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pulihkan Template Mapel SMK',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: tokens.textPrimary,
                              ),
                            ),
                            Text(
                              'Tambahkan kembali mapel bawaan jika ada yang hilang',
                              style: TextStyle(fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Tentang Aplikasi
          Center(
            child: Column(
              children: [
                Text(
                  'Nigas - Pencatat Tugas Siswa SMK',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Versi 1.0.0 • 100% Offline Lokal',
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, NeoBrutalTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: tokens.primaryAccent),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppTheme.monoStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: tokens.textPrimary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
