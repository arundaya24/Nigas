import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/deadline_sticker.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../../../core/widgets/neo_brutal_checkbox.dart';
import '../../../core/widgets/neo_brutal_chip.dart';
import '../../../core/widgets/neo_brutal_empty_state.dart';
import '../../../core/widgets/neo_brutal_task_card.dart';
import '../../../core/widgets/neo_brutal_text_field.dart';
import '../../../core/widgets/segmented_progress_bar.dart';

/// Halaman showcase untuk mendemonstrasikan seluruh komponen Neo-Brutalism
/// dalam mode Terang dan Gelap.
class ShowcaseScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  const ShowcaseScreen({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  bool _sampleCheckbox1 = false;
  bool _sampleCheckbox2 = true;
  int _selectedChipIndex = 0;
  bool _sampleTaskDone = false;
  final TextEditingController _textController =
      TextEditingController(text: 'Laporan Praktikum Routing Statis');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title, NeoBrutalTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 22,
            color: tokens.primaryAccent,
            margin: const EdgeInsets.only(right: 8),
          ),
          Text(
            title.toUpperCase(),
            style: AppTheme.monoStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: tokens.textMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 2,
              color: tokens.borderColor.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.neoBrutal;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tokens.primaryAccent,
                border: Border.all(
                  color: tokens.borderColor,
                  width: tokens.borderWidth,
                ),
              ),
              child: Text(
                AppStrings.appName.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF141414),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Design System',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: NeoBrutalButton(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              variant: NeoBrutalButtonVariant.secondary,
              onPressed: widget.onToggleTheme,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 16,
                    color: tokens.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDark ? 'Mode Terang' : 'Mode Gelap',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Info
          NeoBrutalCard(
            color: tokens.primaryAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.palette,
                      size: 22,
                      color: Color(0xFF141414),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'NEO-BRUTALISM SHOWCASE',
                      style: AppTheme.monoStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF141414),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Komponen kustom bebas dari gradasi, glassmorphism, dan elevasi Material halus. Border tegas 2.5px, sudut 4px, dan bayangan keras solid.',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF141414),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          // 1. BUTTONS SECTION
          _buildSectionHeader('1. Buttons (Efek Terpencet)', tokens),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeoBrutalButton(
                text: 'Primary Yellow',
                variant: NeoBrutalButtonVariant.primary,
                onPressed: () {},
              ),
              NeoBrutalButton(
                text: 'Secondary White',
                variant: NeoBrutalButtonVariant.secondary,
                onPressed: () {},
              ),
              NeoBrutalButton(
                text: 'Success Lime',
                variant: NeoBrutalButtonVariant.success,
                onPressed: () {},
              ),
              NeoBrutalButton(
                text: 'Danger Red',
                variant: NeoBrutalButtonVariant.danger,
                onPressed: () {},
              ),
              NeoBrutalButton(
                text: 'Dengan Ikon',
                icon: const Icon(Icons.add, size: 18),
                variant: NeoBrutalButtonVariant.primary,
                onPressed: () {},
              ),
              NeoBrutalButton(
                text: 'Disabled',
                variant: NeoBrutalButtonVariant.primary,
                onPressed: null,
              ),
            ],
          ),

          // 2. CHECKBOXES SECTION
          _buildSectionHeader('2. Custom Checkbox (Animasi Stempel)', tokens),
          NeoBrutalCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    NeoBrutalCheckbox(
                      value: _sampleCheckbox1,
                      onChanged: (val) =>
                          setState(() => _sampleCheckbox1 = val),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tap untuk centang',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    NeoBrutalCheckbox(
                      value: _sampleCheckbox2,
                      activeColor: AppColors.yellow,
                      onChanged: (val) =>
                          setState(() => _sampleCheckbox2 = val),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Aksen Kuning',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. DEADLINE STICKERS SECTION
          _buildSectionHeader(
              '3. Deadline Stickers (Miring ±2°, Space Mono)', tokens),
          Wrap(
            spacing: 14,
            runSpacing: 16,
            children: const [
              DeadlineSticker(
                text: 'TELAT 2 HARI',
                status: DeadlineStatus.overdue,
                rotationDegrees: -2.5,
              ),
              DeadlineSticker(
                text: 'HARI INI',
                status: DeadlineStatus.today,
                rotationDegrees: 1.8,
              ),
              DeadlineSticker(
                text: 'BESOK 07.00',
                status: DeadlineStatus.tomorrow,
                rotationDegrees: -2.0,
              ),
              DeadlineSticker(
                text: '5 HARI LAGI',
                status: DeadlineStatus.upcoming,
                rotationDegrees: 2.0,
              ),
              DeadlineSticker(
                text: 'SELESAI',
                status: DeadlineStatus.done,
                rotationDegrees: -1.5,
              ),
            ],
          ),

          // 4. CHIPS SECTION
          _buildSectionHeader('4. Filter Chips (Horizontal Mapel)', tokens),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                NeoBrutalChip(
                  label: 'Semua',
                  isSelected: _selectedChipIndex == 0,
                  onTap: () => setState(() => _selectedChipIndex = 0),
                ),
                NeoBrutalChip(
                  label: 'Administrasi Jaringan',
                  activeColor: AppColors.blue,
                  activeTextColor: Colors.white,
                  isSelected: _selectedChipIndex == 1,
                  onTap: () => setState(() => _selectedChipIndex = 1),
                ),
                NeoBrutalChip(
                  label: 'Matematika',
                  activeColor: AppColors.yellow,
                  isSelected: _selectedChipIndex == 2,
                  onTap: () => setState(() => _selectedChipIndex = 2),
                ),
                NeoBrutalChip(
                  label: 'Bahasa Indonesia',
                  activeColor: AppColors.pink,
                  activeTextColor: Colors.white,
                  isSelected: _selectedChipIndex == 3,
                  onTap: () => setState(() => _selectedChipIndex = 3),
                ),
              ],
            ),
          ),

          // 5. SEGMENTED PROGRESS BAR
          _buildSectionHeader('5. Segmented Subtask Progress Bar', tokens),
          NeoBrutalCard(
            child: Column(
              children: const [
                SegmentedProgressBar(
                  total: 4,
                  completed: 2,
                  activeColor: AppColors.lime,
                ),
                SizedBox(height: 16),
                SegmentedProgressBar(
                  total: 5,
                  completed: 5,
                  activeColor: AppColors.yellow,
                ),
              ],
            ),
          ),

          // 6. TASK CARD SAMPLE
          _buildSectionHeader('6. Kartu Tugas Lengkap', tokens),
          NeoBrutalTaskCard(
            title: 'Konfigurasi Mikrotik Router & VLAN Trunking',
            subjectName: 'Teknik Jaringan Komputer',
            subjectColor: AppColors.blue,
            deadlineLabel: 'BESOK 07.00',
            deadlineStatus: DeadlineStatus.tomorrow,
            isDone: _sampleTaskDone,
            totalSubtasks: 4,
            completedSubtasks: _sampleTaskDone ? 4 : 2,
            notes: 'Bawa kabel UTP straight dan catat konfigurasi IP address.',
            onToggleDone: (val) => setState(() => _sampleTaskDone = val),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          NeoBrutalTaskCard(
            title: 'Latihan Soal Matriks dan Vektor Hal. 45',
            subjectName: 'Matematika',
            subjectColor: AppColors.yellow,
            deadlineLabel: 'TELAT 1 HARI',
            deadlineStatus: DeadlineStatus.overdue,
            isDone: false,
            totalSubtasks: 0,
            completedSubtasks: 0,
            onToggleDone: (val) {},
            onTap: () {},
          ),

          // 7. INPUT FIELD SAMPLE
          _buildSectionHeader('7. Neo-Brutal Input Field', tokens),
          NeoBrutalTextField(
            controller: _textController,
            label: 'Judul Tugas',
            hintText: 'Misal: Laporan Praktikum TKJ',
          ),
          const SizedBox(height: 12),
          const NeoBrutalTextField(
            label: 'Input Dengan Error',
            hintText: 'Contoh input invalid...',
            errorText: 'Tenggat waktu tidak boleh sebelum waktu sekarang',
          ),

          // 8. EMPTY STATE SAMPLE
          _buildSectionHeader('8. Empty State Geometris', tokens),
          NeoBrutalCard(
            child: NeoBrutalEmptyState(
              title: AppStrings.emptyPendingTitle,
              subtitle: AppStrings.emptyPendingSubtitle,
              action: NeoBrutalButton(
                text: 'Tambah Tugas Baru',
                icon: const Icon(Icons.add, size: 18),
                variant: NeoBrutalButtonVariant.primary,
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
