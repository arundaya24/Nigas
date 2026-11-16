import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/showcase/presentation/showcase_screen.dart';
import '../../features/subjects/presentation/subjects_screen.dart';
import '../../features/tasks/presentation/category_tasks_screen.dart';
import '../../features/tasks/presentation/home_screen.dart';
import '../../features/tasks/presentation/task_detail_screen.dart';
import '../../features/tasks/presentation/task_form_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
          onCompleted: () => context.go('/'),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/category/:code',
        builder: (context, state) {
          final code = state.pathParameters['code'] ?? 'general';
          return CategoryTasksScreen(categoryCode: code);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'subjects',
            builder: (context, state) => const SubjectsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/showcase',
        builder: (context, state) => ShowcaseScreen(
          onToggleTheme: () {},
          currentThemeMode: ThemeMode.light,
        ),
      ),
      GoRoute(
        path: '/tasks/add',
        builder: (context, state) {
          final cat = state.uri.queryParameters['category'];
          final subIdStr = state.uri.queryParameters['subjectId'];
          final subId = subIdStr != null ? int.tryParse(subIdStr) : null;
          return TaskFormScreen(
            initialCategory: cat,
            initialSubjectId: subId,
          );
        },
      ),
      GoRoute(
        path: '/tasks/edit/:id',
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = idStr != null ? int.tryParse(idStr) : null;
          return TaskFormScreen(taskId: id);
        },
      ),
      GoRoute(
        path: '/tasks/detail/:id',
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = idStr != null ? int.tryParse(idStr) ?? 0 : 0;
          return TaskDetailScreen(taskId: id);
        },
      ),
    ],
  );
});
