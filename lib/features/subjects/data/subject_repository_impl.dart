import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../onboarding/domain/vocational_major.dart';
import '../domain/smk_category.dart';
import '../domain/subject.dart';
import '../domain/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final AppDatabase _db;

  SubjectRepositoryImpl(this._db);

  Subject _toDomain(SubjectEntry entry) {
    return Subject(
      id: entry.id,
      name: entry.name,
      colorIndex: entry.colorIndex,
      isPreset: entry.isPreset,
      category: entry.category,
      createdAt: entry.createdAt,
    );
  }

  @override
  Stream<List<Subject>> watchAllSubjects({String? category}) {
    final query = _db.select(_db.subjects);
    if (category != null && category.isNotEmpty) {
      query.where((t) => t.category.equals(category));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch().map((list) => list.map(_toDomain).toList());
  }

  @override
  Future<List<Subject>> getAllSubjects({String? category}) async {
    final query = _db.select(_db.subjects);
    if (category != null && category.isNotEmpty) {
      query.where((t) => t.category.equals(category));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.name)]);
    final list = await query.get();
    return list.map(_toDomain).toList();
  }

  @override
  Future<Subject?> getSubjectById(int id) async {
    final query = _db.select(_db.subjects)..where((t) => t.id.equals(id));
    final entry = await query.getSingleOrNull();
    return entry != null ? _toDomain(entry) : null;
  }

  @override
  Future<int> createSubject({
    required String name,
    required int colorIndex,
    bool isPreset = false,
    String category = 'general',
  }) async {
    return _db
        .into(_db.subjects)
        .insert(
          SubjectsCompanion.insert(
            name: name,
            colorIndex: Value(colorIndex),
            isPreset: Value(isPreset),
            category: Value(category),
          ),
        );
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    await (_db.update(
      _db.subjects,
    )..where((t) => t.id.equals(subject.id))).write(
      SubjectsCompanion(
        name: Value(subject.name),
        colorIndex: Value(subject.colorIndex),
        category: Value(subject.category),
      ),
    );
  }

  @override
  Future<void> deleteSubject(int id) async {
    await (_db.delete(_db.subjects)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<int> countTasksBySubject(int subjectId) async {
    final countExp = countAll();
    final query = _db.selectOnly(_db.tasks)
      ..addColumns([countExp])
      ..where(_db.tasks.subjectId.equals(subjectId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  @override
  Future<void> moveTasksToSubject({
    required int fromSubjectId,
    required int toSubjectId,
  }) async {
    await (_db.update(_db.tasks)
          ..where((t) => t.subjectId.equals(fromSubjectId)))
        .write(TasksCompanion(subjectId: Value(toSubjectId)));
  }

  @override
  Future<void> seedSubjects(
    List<PresetSubjectItem> subjects, {
    String category = 'general',
  }) async {
    final existingSubjects = await getAllSubjects();
    final existingNames = existingSubjects
        .map((s) => s.name.toLowerCase().trim())
        .toSet();

    await _db.batch((batch) {
      for (final item in subjects) {
        if (!existingNames.contains(item.name.toLowerCase().trim())) {
          batch.insert(
            _db.subjects,
            SubjectsCompanion.insert(
              name: item.name,
              colorIndex: Value(item.colorIndex),
              isPreset: const Value(true),
              category: Value(category),
            ),
          );
        }
      }
    });
  }

  @override
  Future<void> seedDefaultTemplates() async {
    final existingSubjects = await getAllSubjects();
    final existingNames = existingSubjects
        .map((s) => s.name.toLowerCase().trim())
        .toSet();

    final templates = <PresetSubjectItem, String>{};

    for (int i = 0; i < SmkCategory.rpl.templateSubjects.length; i++) {
      templates[PresetSubjectItem(
            name: SmkCategory.rpl.templateSubjects[i],
            colorIndex: (i * 2) % 8,
            isVocational: true,
          )] =
          'rpl';
    }

    for (int i = 0; i < SmkCategory.tkj.templateSubjects.length; i++) {
      templates[PresetSubjectItem(
            name: SmkCategory.tkj.templateSubjects[i],
            colorIndex: (i * 2 + 1) % 8,
            isVocational: true,
          )] =
          'tkj';
    }

    for (int i = 0; i < SmkCategory.dkv.templateSubjects.length; i++) {
      templates[PresetSubjectItem(
            name: SmkCategory.dkv.templateSubjects[i],
            colorIndex: (i * 2 + 4) % 8,
            isVocational: true,
          )] =
          'dkv';
    }

    for (int i = 0; i < SmkCategory.general.templateSubjects.length; i++) {
      templates[PresetSubjectItem(
            name: SmkCategory.general.templateSubjects[i],
            colorIndex: i % 8,
          )] =
          'general';
    }

    await _db.batch((batch) {
      for (final entry in templates.entries) {
        final item = entry.key;
        final cat = entry.value;
        if (!existingNames.contains(item.name.toLowerCase().trim())) {
          batch.insert(
            _db.subjects,
            SubjectsCompanion.insert(
              name: item.name,
              colorIndex: Value(item.colorIndex),
              isPreset: const Value(true),
              category: Value(cat),
            ),
          );
        }
      }
    });
  }
}
