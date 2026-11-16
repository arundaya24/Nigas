import '../../onboarding/domain/vocational_major.dart';
import 'subject.dart';

/// Kontrak Repository untuk Mata Pelajaran.
abstract class SubjectRepository {
  Stream<List<Subject>> watchAllSubjects({String? category});
  Future<List<Subject>> getAllSubjects({String? category});
  Future<Subject?> getSubjectById(int id);
  Future<int> createSubject({
    required String name,
    required int colorIndex,
    bool isPreset = false,
    String category = 'general',
  });
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(int id);
  Future<int> countTasksBySubject(int subjectId);
  Future<void> moveTasksToSubject({
    required int fromSubjectId,
    required int toSubjectId,
  });
  Future<void> seedSubjects(List<PresetSubjectItem> subjects, {String category = 'general'});
  Future<void> seedDefaultTemplates();
}
