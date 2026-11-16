import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';
import '../../../subjects/domain/smk_category.dart';

/// Kartu pilihan jurusan SMK (RPL, TKJ, DKV) yang interaktif dan dapat diklik.
class MajorCard extends StatefulWidget {
  final SmkCategory category;
  final int activeTaskCount;
  final VoidCallback onTap;

  const MajorCard({
    super.key,
    required this.category,
    required this.activeTaskCount,
    required this.onTap,
  });

  @override
  State<MajorCard> createState() => _MajorCardState();
}

class _MajorCardState extends State<MajorCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final cat = widget.category;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: tokens.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? cat.primaryColor : tokens.borderColor,
                width: _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? cat.primaryColor.withValues(alpha: 0.15)
                      : tokens.shadowColor,
                  blurRadius: _isHovered ? 12 : 8,
                  offset: _isHovered ? const Offset(0, 4) : const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Atas: Ikon + Nama Jurusan + Counter Tugas + Arrow
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lingkaran Ikon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cat.lightColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        cat.icon,
                        color: cat.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Judul Jurusan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                cat.shortName,
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: tokens.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.activeTaskCount > 0
                                      ? cat.primaryColor.withValues(alpha: 0.12)
                                      : tokens.borderColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.activeTaskCount > 0
                                      ? '${widget.activeTaskCount} tugas'
                                      : '0 tugas',
                                  style: AppTheme.monoStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: widget.activeTaskCount > 0
                                        ? cat.primaryColor
                                        : tokens.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat.fullName,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: tokens.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Panah Navigasi
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tokens.scaffoldBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: cat.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Baris Bawah: Chip Preview Mapel Template
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: cat.templateSubjects.take(3).map((mapel) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.scaffoldBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: tokens.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        mapel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: tokens.textPrimary,
                        ),
                      ),
                    );
                  }).toList()
                    ..add(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: cat.lightColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${cat.templateSubjects.length - 3} lainnya',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: cat.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

