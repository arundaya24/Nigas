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
    description: 'Pemrograman web, mobile, basis data, dan algoritma',
    icon: Icons.code_rounded,
    primaryColor: Color(0xFF4F46E5), // Indigo
    lightColor: Color(0xFFEEF2FF),
    templateSubjects: [
      'Pemrograman Web & Bergerak',
      'Pemrograman Berorientasi Objek',
      'Basis Data',
      'Pemodelan Perangkat Lunak',
    ],
  );

  static const SmkCategory tkj = SmkCategory(
    code: 'tkj',
    shortName: 'TKJ',
    fullName: 'Teknik Komputer & Jaringan',
    description: 'Jaringan komputer, routing, server, dan infrastruktur IT',
    icon: Icons.lan_rounded,
    primaryColor: Color(0xFF0284C7), // Sky Blue
    lightColor: Color(0xFFE0F2FE),
    templateSubjects: [
      'Administrasi Infrastruktur Jaringan',
      'Administrasi Sistem Jaringan',
      'Teknologi Jaringan Berbasis Luas (WAN)',
      'Teknologi Layanan Jaringan',
    ],
  );

  static const SmkCategory dkv = SmkCategory(
    code: 'dkv',
    shortName: 'DKV',
    fullName: 'Desain Komunikasi Visual',
    description: 'Desain grafis, animasi 2D/3D, audio video, dan fotografi',
    icon: Icons.palette_rounded,
    primaryColor: Color(0xFFE11D48), // Rose
    lightColor: Color(0xFFFFE4E6),
    templateSubjects: [
      'Desain Grafis Percetakan',
      'Animasi 2D dan 3D',
      'Teknik Pengolahan Audio & Video',
      'Fotografi & Media Interaktif',
    ],
  );

  static const SmkCategory general = SmkCategory(
    code: 'general',
    shortName: 'Mapel Umum',
    fullName: 'Mata Pelajaran Umum',
    description: 'Matematika, Bahasa Indonesia, Bahasa Inggris, dll.',
    icon: Icons.auto_stories_rounded,
    primaryColor: Color(0xFF059669), // Emerald
    lightColor: Color(0xFFD1FAE5),
    templateSubjects: [
      'Matematika',
      'Bahasa Indonesia',
      'Bahasa Inggris',
      'PPKn',
      'Pendidikan Agama & Budi Pekerti',
      'PJOK',
      'Sejarah Indonesia',
      'Seni Budaya',
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

