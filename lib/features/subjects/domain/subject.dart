import 'smk_category.dart';

/// Model domain murni untuk Mata Pelajaran.
/// UI dan business logic menggunakan model ini (terisolasi dari Drift).
class Subject {
  final int id;
  final String name;
  final int colorIndex;
  final bool isPreset;
  final String category; // 'rpl', 'tkj', 'dkv', 'general'
  final DateTime createdAt;

  const Subject({
    required this.id,
    required this.name,
    required this.colorIndex,
    required this.isPreset,
    this.category = 'general',
    required this.createdAt,
  });

  SmkCategory get smkCategory => SmkCategory.fromCode(category);

  Subject copyWith({
    int? id,
    String? name,
    int? colorIndex,
    bool? isPreset,
    String? category,
    DateTime? createdAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      isPreset: isPreset ?? this.isPreset,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subject &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          colorIndex == other.colorIndex &&
          isPreset == other.isPreset &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      colorIndex.hashCode ^
      isPreset.hashCode ^
      category.hashCode;
}
