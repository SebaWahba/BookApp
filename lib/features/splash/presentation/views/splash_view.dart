import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const _animationDuration = Duration(milliseconds: 800);
  static const _navigationDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();

    Future.delayed(_navigationDelay, () {
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary500,
      body: Stack(
        children: [
          // Background Gradient Layer
          Positioned(
            top: 495,
            left: -30,
            child: Transform.rotate(
              angle: -90 * math.pi / 180,
              child: SvgPicture.asset(
                AppAssets.splashGradient,
                width: 316.61,
                height: 315.86,
              ),
            ),
          ),
          // Content Layer (Logo + App Name)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: SvgPicture.asset(
                      AppAssets.logo,
                      width: 37.94,
                      height: 37.85,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.62),
                  Text(
                    'Bazar.',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.white,
                      fontSize: 31.55,
                      letterSpacing: -1.262,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


