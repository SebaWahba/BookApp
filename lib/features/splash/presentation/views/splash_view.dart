import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // was not specified in the figma
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {   // was not specified in the figma
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
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
      backgroundColor: const Color(0xFF54408C),
      body: Stack(
        children: [
          // Layer 1
          Positioned(
            top: 495,
            left: -30,
            child: Transform.rotate(
              angle: -90 * math.pi / 180,
              child: SvgPicture.asset(
                'assets/icons/Vectorbig.svg',
                width: 316.61,
                height: 315.86,
              ),
            ),
          ),
          // Layer 2
          Positioned(
            top: 376,
            left: 80,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: SvgPicture.asset(
                      'assets/icons/Vector.svg',
                      width: 37.94,
                      height: 37.85,
                      colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 12.62),
                  Text(
                    'Bazar.',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 31.55,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.262,
                      height: 1.4,
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




