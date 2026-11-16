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

/// Provider instans database Drift tunggal
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider SubjectRepository
final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SubjectRepositoryImpl(db);
});

/// Provider TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db);
});

/// Provider SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(db);
});

/// Stream reactive untuk semua mata pelajaran
final subjectsStreamProvider = StreamProvider<List<Subject>>((ref) {
  final repo = ref.watch(subjectRepositoryProvider);
  return repo.watchAllSubjects();
});

/// Stream reactive untuk mapel per kategori ('rpl', 'tkj', 'dkv', 'general')
final categorySubjectsStreamProvider =
    StreamProvider.family<List<Subject>, String>((ref, category) {
  final repo = ref.watch(subjectRepositoryProvider);
  return repo.watchAllSubjects(category: category);
});

/// State filter mapel aktif di beranda (null = Semua)
final selectedSubjectFilterProvider = StateProvider<int?>((ref) => null);

/// Stream reactive untuk pengaturan aplikasi
final appSettingsStreamProvider = StreamProvider<AppSettingsData>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
});

/// Provider untuk mengecek apakah onboarding sudah selesai
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.hasCompletedOnboarding();
});

/// Provider inisialisasi template mapel SMK (RPL, TKJ, DKV, Mapel Umum)
final initTemplatesProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(subjectRepositoryProvider);
  await repo.seedDefaultTemplates();
});

/// Provider NotificationService tunggal
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});
