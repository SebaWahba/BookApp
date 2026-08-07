import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/buttons/secondary_button.dart';
import 'package:bookapp/core/constants/app_sizing.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/services/app_preferences.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingPageIndexProvider.notifier).setPage(0);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Leaves for sign-in and records that onboarding is done, so the next launch
  /// resolves to login rather than showing these pages again.
  void _finishOnboarding() {
    // Fire-and-forget: navigation shouldn't wait on a disk write, and showing
    // onboarding once more is a harmless outcome if it fails.
    ref.read(appPreferencesProvider).setOnboardingSeen();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final currentPage = ref.watch(onboardingPageIndexProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= AppBreakpoints.mobile;

    final horizontalPadding = isTablet
        ? screenWidth * 0.12
        : AppSpacing.screenPadding;

    final maxControlsWidth = isTablet ? 480.0 : double.infinity;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 500;
            final topGap = isCompact ? 4.0 : 16.0;
            final beforeControlsGap = isCompact ? 8.0 : 40.0;
            final betweenControlsGap = isCompact ? 6.0 : 40.0;
            final bottomGap = isCompact ? 4.0 : 24.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topGap),
                  GestureDetector(
                    onTap: () {
                      _finishOnboarding();
                    },
                    child: Text(
                      l10n.onboardingSkip,
                      style: AppTextStyles.bodyLargeSemiBold.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                  SizedBox(height: topGap),
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
                  SizedBox(height: beforeControlsGap),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxControlsWidth),
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
                  ),
                  SizedBox(height: betweenControlsGap),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxControlsWidth),
                      child: Column(
                        children: [
                          PrimaryButton(
                            text: currentPage == onbaordingDataList.length - 1
                                ? l10n.onboardingGetStarted
                                : l10n.onboardingContinue,
                            onPressed: () {
                              if (currentPage ==
                                  onbaordingDataList.length - 1) {
                                _finishOnboarding();
                                return;
                              }
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          SizedBox(height: isCompact ? 6.0 : 12.0),
                          SecondaryButton(
                            onPressed: () {
                              _finishOnboarding();
                            },
                            text: l10n.signInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: bottomGap),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}