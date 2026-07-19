import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/buttons/secondary_button.dart';
import 'package:bookapp/core/constants/app_sizing.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
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
    final isFirstPage = currentPage == 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).go(AppRoutes.login);
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (int index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(model: onbaordingDataList[index]);
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
                    dotColor: AppColors.grey200,
                    spacing: AppSizing.indicatorSpacing,
                    dotHeight: AppSizing.indicatorDotHeight,
                    dotWidth: AppSizing.indicatorDotWidth,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: isFirstPage ? "Continue" : "Get Started",
                onPressed: () {
                  if (currentPage == onbaordingDataList.length - 1) {
                    GoRouter.of(context).go(AppRoutes.login);
                    return;
                  }

                  controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                onPressed: () {
                  GoRouter.of(context).go(AppRoutes.login);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
