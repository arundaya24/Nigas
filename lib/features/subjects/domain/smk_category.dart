import 'package:flutter/material.dart';

/// Kategori jurusan & mapel umum SMK:
/// - RPL (Rekayasa Perangkat Lunak)
/// - TKJ (Teknik Komputer & Jaringan)
/// - DKV (Desain Komunikasi Visual)
/// - GENERAL (Mata Pelajaran Umum)
class SmkCategory {
  final String code;
  final String shortName;
  final String fullName;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color lightColor;
  final List<String> templateSubjects;

  const SmkCategory({
    required this.code,
    required this.shortName,
    required this.fullName,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.lightColor,
    required this.templateSubjects,
  });

  static const SmkCategory rpl = SmkCategory(
    code: 'rpl',
    shortName: 'RPL',
    fullName: 'Rekayasa Perangkat Lunak',
    description: 'PAD, PWEB, PPB, UI/UX, dan APS',
    icon: Icons.code_rounded,
    primaryColor: Color(0xFF64748B), // Abu-abu (Slate)
    lightColor: Color(0xFFF1F5F9),
    templateSubjects: [
      'PAD',
      'PWEB',
      'PPB',
      'UI/UX',
      'APS',
    ],
  );

  static const SmkCategory tkj = SmkCategory(
    code: 'tkj',
    shortName: 'TKJ',
    fullName: 'Teknik Komputer & Jaringan',
    description: 'ASJ, KEJAR, KPJ, DMIKRO, TJKN, dan PPJ',
    icon: Icons.lan_rounded,
    primaryColor: Color(0xFF18181B), // Hitam (Onyx)
    lightColor: Color(0xFFE4E4E7),
    templateSubjects: [
      'ASJ',
      'KEJAR',
      'KPJ',
      'DMIKRO',
      'TJKN',
      'PPJ',
    ],
  );

  static const SmkCategory dkv = SmkCategory(
    code: 'dkv',
    shortName: 'DKV',
    fullName: 'Desain Komunikasi Visual',
    description: 'Fotografi, Videografi, KPD, DP, Desain Cetak, dan AMG',
    icon: Icons.palette_rounded,
    primaryColor: Color(0xFF1E3A8A), // Biru Tua (Navy)
    lightColor: Color(0xFFEFF6FF),
    templateSubjects: [
      'Fotografi',
      'Videografi',
      'KPD',
      'DP',
      'Desain Cetak',
      'AMG',
    ],
  );

  static const SmkCategory general = SmkCategory(
    code: 'general',
    shortName: 'Mapel Umum',
    fullName: 'Mata Pelajaran Umum',
    description: 'PAI, PKK, PPKn, B. Indo, MTK, dll.',
    icon: Icons.auto_stories_rounded,
    primaryColor: Color(0xFF0F766E), // Teal Netral
    lightColor: Color(0xFFCCFBF1),
    templateSubjects: [
      'PAI',
      'PKK',
      'PPKn',
      'B. Indo',
      'B. Inggris',
      'Sejarah',
      'MTK',
      'PJOK',
      'B. Jepang',
      'BTQ',
      'BP/BK',
    ],
  );

  static const List<SmkCategory> majors = [rpl, tkj, dkv];
  static const List<SmkCategory> all = [rpl, tkj, dkv, general];

  static SmkCategory fromCode(String? code) {
    switch (code?.toLowerCase()) {
      case 'rpl':
        return rpl;
      case 'tkj':
        return tkj;
      case 'dkv':
        return dkv;
      case 'general':
      default:
        return general;
    }
  }
}

