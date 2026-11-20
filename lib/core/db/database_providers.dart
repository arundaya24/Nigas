import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/reminders/notification_service.dart';
import '../../features/settings/data/settings_repository_impl.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../features/settings/domain/settings_repository.dart';
import '../../features/subjects/data/subject_repository_impl.dart';
import '../../features/subjects/domain/subject.dart';
import '../../features/subjects/domain/subject_repository.dart';
import '../../features/tasks/data/task_repository_impl.dart';
import '../../features/tasks/domain/task_repository.dart';
import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SubjectRepositoryImpl(db);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(db);
});

final subjectsStreamProvider = StreamProvider<List<Subject>>((ref) {
  final repo = ref.watch(subjectRepositoryProvider);
  return repo.watchAllSubjects();
});

final categorySubjectsStreamProvider =
    StreamProvider.family<List<Subject>, String>((ref, category) {
      final repo = ref.watch(subjectRepositoryProvider);
      return repo.watchAllSubjects(category: category);
    });

final selectedSubjectFilterProvider = StateProvider<int?>((ref) => null);

final appSettingsStreamProvider = StreamProvider<AppSettingsData>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
});

final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.hasCompletedOnboarding();
});

final initTemplatesProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(subjectRepositoryProvider);
  await repo.seedDefaultTemplates();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});
