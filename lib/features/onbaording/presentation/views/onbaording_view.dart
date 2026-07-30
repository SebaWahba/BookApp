import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/buttons/secondary_button.dart';
import 'package:bookapp/core/constants/app_sizing.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:bookapp/features/onbaording/presentation/providers/onboarding_provider.dart';
import 'package:bookapp/features/onbaording/presentation/widgets/onboarding_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class OnbaordingView extends ConsumerStatefulWidget {
  const OnbaordingView({super.key});

  @override
  ConsumerState<OnbaordingView> createState() => _OnbaordingViewState();
}

class _OnbaordingViewState extends ConsumerState<OnbaordingView> {
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    // Reset page index every time onboarding opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingPageIndexProvider.notifier).setPage(0);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPage = ref.watch(onboardingPageIndexProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.login);
                },
                child: Text(
                  l10n.onboardingSkip,
                  style: const TextStyle(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (int index) {
                    ref
                        .read(onboardingPageIndexProvider.notifier)
                        .setPage(index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(
                      model: onbaordingDataList[index],
                    );
                  },
                  itemCount: onbaordingDataList.length,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: onbaordingDataList.length,
                  onDotClicked: (index) {
                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  effect: WormEffect(
                    activeDotColor: AppColors.primary500,
                    dotColor: isDark ? Colors.grey[700]! : AppColors.grey200,
                    spacing: AppSizing.indicatorSpacing,
                    dotHeight: AppSizing.indicatorDotHeight,
                    dotWidth: AppSizing.indicatorDotWidth,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: currentPage == onbaordingDataList.length - 1
                    ? l10n.onboardingGetStarted
                    : l10n.onboardingContinue,
                onPressed: () {
                  if (currentPage == onbaordingDataList.length - 1) {
                    context.go(AppRoutes.login);
                    return;
                  }
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                onPressed: () {
                  context.go(AppRoutes.login);
                },
                text: l10n.signInButton,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}