import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/neo_brutal_tokens.dart';
import '../../../core/widgets/deadline_sticker.dart';
import '../../../core/widgets/neo_brutal_button.dart';
import '../../../core/widgets/neo_brutal_card.dart';
import '../domain/vocational_major.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  final VoidCallback? onCompleted;

  const OnboardingScreen({
    super.key,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.neoBrutal;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: tokens.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.primaryAccent,
                          border: Border.all(
                            color: tokens.borderColor,
                            width: tokens.borderWidth,
                          ),
                        ),
                        child: Text(
                          AppStrings.appName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xFF141414),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const DeadlineSticker(
                        text: 'LANGKAH PERTAMA',
                        status: DeadlineStatus.today,
                        rotationDegrees: 1.5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AppStrings.onboardingTitle,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: tokens.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.onboardingSubtitle,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 2),

            // List Jurusan
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: kVocationalMajors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final major = kVocationalMajors[index];
                  final isSelected = state.selectedMajor.code == major.code;

                  return NeoBrutalCard(
                    color: isSelected
                        ? tokens.primaryAccent.withValues(alpha: 0.18)
                        : tokens.cardBg,
                    borderColor: isSelected
                        ? tokens.borderColor
                        : tokens.borderColor.withValues(alpha: 0.6),
                    onTap: () => controller.selectMajor(major),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Badge Kode Jurusan
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? tokens.primaryAccent
                                    : const Color(0xFFE5E7EB),
                                border: Border.all(
                                  color: tokens.borderColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                major.code,
                                style: AppTheme.monoStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF141414),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                major.name,
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: tokens.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: tokens.primaryAccent,
                                  border: Border.all(
                                    color: tokens.borderColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color(0xFF141414),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          major.description,
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12.5,
                            color: tokens.textMuted,
                            height: 1.3,
                          ),
                        ),
                        if (major.vocationalSubjects.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: major.vocationalSubjects.map((sub) {
                              final color =
                                  AppColors.getSubjectColor(sub.colorIndex);
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: tokens.borderColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  sub.name,
                                  style: TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: tokens.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: tokens.cardBg,
                border: Border(
                  top: BorderSide(
                    color: tokens.borderColor,
                    width: tokens.borderWidth,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.errorMessage != null) ...[
                    Text(
                      state.errorMessage!,
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  NeoBrutalButton(
                    width: double.infinity,
                    height: 52,
                    text: state.isLoading
                        ? 'Menyiapkan Mata Pelajaran...'
                        : AppStrings.startApp,
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Color(0xFF141414),
                            ),
                          )
                        : const Icon(Icons.arrow_forward, size: 20),
                    variant: NeoBrutalButtonVariant.primary,
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            final success =
                                await controller.completeOnboarding();
                            if (success && onCompleted != null) {
                              onCompleted!();
                            }
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

