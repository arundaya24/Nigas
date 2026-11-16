import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neo_brutal_tokens.dart';
import '../../../subjects/domain/smk_category.dart';

/// Kartu menu Mata Pelajaran Umum yang interaktif dan dapat diklik.
class GeneralSubjectsCard extends StatefulWidget {
  final int activeTaskCount;
  final VoidCallback onTap;

  const GeneralSubjectsCard({
    super.key,
    required this.activeTaskCount,
    required this.onTap,
  });

  @override
  State<GeneralSubjectsCard> createState() => _GeneralSubjectsCardState();
}

class _GeneralSubjectsCardState extends State<GeneralSubjectsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brutalTheme;
    final cat = SmkCategory.general;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mata Pelajaran Umum',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 16.0,
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
                            cat.description,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: tokens.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    'Matematika',
                    'B. Indonesia',
                    'B. Inggris',
                    'PPKn',
                  ].map((mapel) {
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
                          '+4 mapel wajib',
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

