import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/db/database_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../../reminders/notification_service.dart';
import '../domain/app_settings.dart';

/// Halaman Pengaturan Aplikasi: Tema, Waktu Pengingat, Manajemen Mapel & Data, serta Info Privasi.
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
      builder: (ctx, child) {
        // Reset inputDecorationTheme agar padding dan border global
        // tidak mengganggu layout internal TimePicker text input mode.
        final theme = Theme.of(ctx);
        return Theme(
          data: theme.copyWith(
            inputDecorationTheme: const InputDecorationTheme(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      await onSaved(picked);
    }
  }

  void _showClearCompletedDialog(BuildContext context, WidgetRef ref) {
    final tokens = context.brutalTheme;
    final settingsRepo = ref.read(settingsRepositoryProvider);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
                'Hapus Tugas Selesai?',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Seluruh tugas dengan status "Selesai" akan dihapus permanen dari perangkat.',
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
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                  const SizedBox(width: 8),
                  NeoBrutalButton(
                    height: 40,
                    text: 'Hapus Selesai',
                    variant: NeoBrutalButtonVariant.danger,
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      final count = await settingsRepo.clearCompletedTasks();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              count > 0
                                  ? '$count tugas selesai berhasil dibersihkan.'
                                  : 'Tidak ada tugas selesai yang perlu dihapus.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetAllDataDialog(BuildContext context, WidgetRef ref) {
    final tokens = context.brutalTheme;
    final settingsRepo = ref.read(settingsRepositoryProvider);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reset Semua Data?',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Tindakan ini akan menghapus SEMUA tugas, subtugas, dan mata pelajaran kustom. Template bawaan SMK akan dipulihkan seperti saat pertama kali diinstal.',
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
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                  const SizedBox(width: 8),
                  NeoBrutalButton(
                    height: 40,
                    text: 'Reset Data',
                    variant: NeoBrutalButtonVariant.danger,
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await NotificationService.instance.cancelAllReminders();
                      await settingsRepo.resetAllData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aplikasi telah di-reset ke kondisi awal.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final tokens = context.brutalTheme;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Nigas',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Versi 1.0.0',
                    style: AppTheme.monoStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: tokens.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Nigas adalah aplikasi pencatat dan pelacak tugas sekolah yang dirancang khusus untuk siswa SMK di Indonesia (RPL, TKJ, DKV, dan Mata Pelajaran Umum).',
                style: TextStyle(
                  fontSize: 13.5,
                  color: tokens.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fitur Utama:',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '• Kategori mapel kejuruan & umum otomatis\n'
                '• Checklist subtugas langkah pengerjaan\n'
                '• Pengingat deadline H-1 dan Hari-H\n'
                '• Mode Gelap & Terang\n'
                '• 100% Offline Lokal tanpa koneksi internet',
                style: TextStyle(
                  fontSize: 12.5,
                  color: tokens.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: NeoBrutalButton(
                  height: 38,
                  text: 'Tutup',
                  variant: NeoBrutalButtonVariant.secondary,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final tokens = context.brutalTheme;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
              Row(
                children: [
                  const Icon(Icons.shield_outlined,
                      color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Privasi & Keamanan Data',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Nigas memprioritaskan privasi penuh siswa:',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Penyimpanan Lokal Mandiri\n'
                'Semua data tugas, jadwal, catatan, dan pengaturan disimpan 100% secara lokal di perangkatmu menggunakan database terenkripsi SQLite.\n\n'
                '2. Tanpa Akun & Tanpa Pelacakan\n'
                'Nigas tidak memerlukan pendaftaran akun, tidak mengumpulkan data pribadi, dan tidak memuat analitik pelacak.\n\n'
                '3. Tanpa Pengiriman ke Server\n'
                'Aplikasi bekerja penuh secara offline tanpa pernah mengirim data ke server mana pun.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: tokens.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: NeoBrutalButton(
                  height: 38,
                  text: 'Mengerti',
                  variant: NeoBrutalButtonVariant.primary,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.brutalTheme;
    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final subjectRepo = ref.read(subjectRepositoryProvider);

    final settings = settingsAsync.valueOrNull ?? const AppSettingsData();

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
                  'Pilih tema terang, gelap, atau ikuti preferensi sistem perangkatmu.',
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
                        onTap: () => settingsRepo.saveThemeMode(ThemeMode.light),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NeoBrutalChip(
                        label: 'Gelap',
                        isSelected: settings.themeMode == ThemeMode.dark,
                        leading: const Icon(Icons.nightlight_outlined, size: 16),
                        onTap: () => settingsRepo.saveThemeMode(ThemeMode.dark),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NeoBrutalChip(
                        label: 'Sistem',
                        isSelected: settings.themeMode == ThemeMode.system,
                        leading: const Icon(Icons.settings_system_daydream,
                            size: 16),
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

          // 2. Jam Pengingat Tugas & Notifikasi
          _buildSectionHeader('PENGINGAT & NOTIFIKASI',
              Icons.notifications_outlined, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Master Toggle Switch
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: settings.notificationsEnabled
                            ? AppColors.primaryLight
                            : tokens.borderColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        settings.notificationsEnabled
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        color: settings.notificationsEnabled
                            ? AppColors.primary
                            : tokens.textMuted,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifikasi Pengingat',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: tokens.textPrimary,
                            ),
                          ),
                          Text(
                            settings.notificationsEnabled
                                ? 'Notifikasi aktif untuk jadwal deadline'
                                : 'Pengingat dimatikan',
                            style: TextStyle(
                                fontSize: 12, color: tokens.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: settings.notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) async {
                        if (val) {
                          await NotificationService.instance
                              .requestPermissions(context);
                        } else {
                          await NotificationService.instance
                              .cancelAllReminders();
                        }
                        await settingsRepo.saveNotificationsEnabled(val);
                      },
                    ),
                  ],
                ),
                if (settings.notificationsEnabled) ...[
                  Divider(
                      color: tokens.borderColor.withValues(alpha: 0.5),
                      height: 20),

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
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.alarm,
                                color: AppColors.primary, size: 20),
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
                                  'Notifikasi sehari sebelum deadline tiba',
                                  style: TextStyle(
                                      fontSize: 12, color: tokens.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: tokens.scaffoldBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: tokens.borderColor, width: 1),
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
                  Divider(
                      color: tokens.borderColor.withValues(alpha: 0.5),
                      height: 16),

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
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.statusTodoBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.today_rounded,
                                color: AppColors.statusTodo, size: 20),
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
                                  'Notifikasi di pagi hari batas pengumpulan',
                                  style: TextStyle(
                                      fontSize: 12, color: tokens.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: tokens.scaffoldBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: tokens.borderColor, width: 1),
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Kelola Mapel
          _buildSectionHeader(
              'MATA PELAJARAN', Icons.auto_stories_outlined, tokens),
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
                        child: const Icon(Icons.edit_note_rounded,
                            color: AppColors.generalPrimary, size: 20),
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
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: tokens.textMuted),
                    ],
                  ),
                ),
                Divider(
                    color: tokens.borderColor.withValues(alpha: 0.5),
                    height: 16),
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
                        child: const Icon(Icons.restore_rounded,
                            color: AppColors.rplPrimary, size: 20),
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
                              'Tambahkan kembali mapel bawaan jika ada yang terhapus',
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
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
          const SizedBox(height: 20),

          // 4. Manajemen Data
          _buildSectionHeader(
              'MANAJEMEN DATA', Icons.storage_rounded, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Hapus Tugas Selesai
                InkWell(
                  onTap: () => _showClearCompletedDialog(context, ref),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.statusDoneBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.cleaning_services_rounded,
                            color: AppColors.statusDone, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bersihkan Tugas Selesai',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: tokens.textPrimary,
                              ),
                            ),
                            Text(
                              'Hapus semua tugas yang telah diselesaikan',
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: tokens.textMuted),
                    ],
                  ),
                ),
                Divider(
                    color: tokens.borderColor.withValues(alpha: 0.5),
                    height: 16),

                // Reset Semua Data
                InkWell(
                  onTap: () => _showResetAllDataDialog(context, ref),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.delete_forever_rounded,
                            color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset Seluruh Data Aplikasi',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Hapus seluruh tugas & kembalikan ke kondisi pabrik',
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: tokens.textMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Tentang & Privasi
          _buildSectionHeader('TENTANG & PRIVASI', Icons.info_outline_rounded, tokens),
          NeoBrutalCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showAboutDialog(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tentang Nigas',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: tokens.textPrimary,
                              ),
                            ),
                            Text(
                              'Informasi rilis, arsitektur, dan versi aplikasi',
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: tokens.textMuted),
                    ],
                  ),
                ),
                Divider(
                    color: tokens.borderColor.withValues(alpha: 0.5),
                    height: 16),
                InkWell(
                  onTap: () => _showPrivacyDialog(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.statusDoneBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lock_outline_rounded,
                            color: AppColors.statusDone, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kebijakan Privasi',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: tokens.textPrimary,
                              ),
                            ),
                            Text(
                              'Jaminan 100% offline, data lokal, tanpa pelacakan',
                              style: TextStyle(
                                  fontSize: 12, color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: tokens.textMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Footer info
          Center(
            child: Column(
              children: [
                Text(
                  'Nigas – Tugas SMK',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Versi 1.0.0 (Build 1) • Offline-First SQLite',
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, NeoBrutalTokens tokens) {
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
