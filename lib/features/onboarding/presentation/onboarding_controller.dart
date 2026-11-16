import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/database_providers.dart';
import '../domain/vocational_major.dart';

class OnboardingState {
  final VocationalMajor selectedMajor;
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    required this.selectedMajor,
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    VocationalMajor? selectedMajor,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      selectedMajor: selectedMajor ?? this.selectedMajor,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref)
      : super(OnboardingState(selectedMajor: kVocationalMajors[0]));

  void selectMajor(VocationalMajor major) {
    state = state.copyWith(selectedMajor: major);
  }

  Future<bool> completeOnboarding() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final subjectRepo = _ref.read(subjectRepositoryProvider);
      final settingsRepo = _ref.read(settingsRepositoryProvider);

      // 1. Seed mata pelajaran umum
      await subjectRepo.seedSubjects(kGeneralSubjects);

      // 2. Seed mata pelajaran kejuruan untuk jurusan yang dipilih
      if (state.selectedMajor.vocationalSubjects.isNotEmpty) {
        await subjectRepo.seedSubjects(state.selectedMajor.vocationalSubjects);
      }

      // 3. Simpan jurusan & tandai onboarding selesai
      await settingsRepo.completeOnboarding(state.selectedMajor.code);

      // 4. Invalidate provider status onboarding agar UI berpindah secara reaktif
      _ref.invalidate(hasCompletedOnboardingProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menyiapkan data: $e',
      );
      return false;
    }
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

