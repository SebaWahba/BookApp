import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/buttons/secondary_button.dart';
import 'package:bookapp/core/components/buttons/skip_button.dart';
import 'package:bookapp/core/constants/app_sizing.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/constants/app_strings.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:bookapp/features/onbaording/presentation/widgets/onboarding_page_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbaordingView extends StatefulWidget {
  const OnbaordingView({super.key});

  @override
  State<OnbaordingView> createState() => _OnbaordingViewState();
}

class _OnbaordingViewState extends State<OnbaordingView> {
  late final PageController controller;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == onbaordingDataList.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.appBarLeadingPadding),
          child: SkipButton(
            onPressed: () {
              GoRouter.of(context).go(AppRoutes.login);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (AppSpacing.screenPadding * 2),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 400,
                          child: PageView.builder(
                            controller: controller,
                            onPageChanged: (int index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return OnboardingPageContent(
                                model: onbaordingDataList[index],
                              );
                            },
                            itemCount: onbaordingDataList.length,
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
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
                          dotColor: AppColors.grey200,
                          spacing: AppSizing.indicatorSpacing,
                          dotHeight: AppSizing.indicatorDotHeight,
                          dotWidth: AppSizing.indicatorDotWidth,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      PrimaryButton(
                        text: isLastPage ? AppStrings.onboardingGetStarted : AppStrings.onboardingContinue,
                        onPressed: () {
                          if (isLastPage) {
                            GoRouter.of(context).go(AppRoutes.login);
                            return;
                          }

                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      SecondaryButton(
                        onPressed: () {
                          GoRouter.of(context).go(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}