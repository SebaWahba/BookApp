import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../providers/startup_provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
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

    _goToStartDestination();
  }

  /// Holds the branding for [_navigationDelay] while the destination resolves
  /// in parallel, so the auth check costs no extra time on screen.
  Future<void> _goToStartDestination() async {
    final destination = ref.read(startDestinationProvider.future);

    await Future.delayed(_navigationDelay);
    final resolved = await destination;

    if (!mounted) return;
    context.go(resolved.route);
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            // Size the decorative shape off the shorter screen dimension so
            // it can never approach full-screen height on short/landscape
            // canvases. 0.82 preserves roughly the same visual weight it
            // had on a phone portrait frame (316 / 375 ≈ 0.84 of frame width).
            final gradientSize =
                math.min(availableWidth, availableHeight) * 0.82;

            // Intended position: ~61% down, bled 8% off the left edge
            // (derived from the original design frame: 495/812 ≈ 0.6096,
            // -30/375 ≈ -0.08). Clamp top so the shape's bottom edge can
            // never exceed availableHeight — that's what was pushing it
            // below the visible canvas in landscape/tablet.
            final top = (availableHeight * 0.6096).clamp(
              0.0,
              availableHeight - gradientSize,
            );
            final left = availableWidth * -0.08;

            return Stack(
              children: [
                // Background Gradient Layer
                Positioned(
                  top: top,
                  left: left,
                  child: Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: SvgPicture.asset(
                      AppAssets.splashGradient,
                      width: gradientSize,
                      height: gradientSize,
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
                            width: 37.94.w,
                            height: 37.85.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.62.w),
                        Text(
                          'Bazar.',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.white,
                            fontSize: 31.55.sp,
                            letterSpacing: -1.262.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
