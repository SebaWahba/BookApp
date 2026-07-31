import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class VendorCard extends ConsumerWidget {
  final String logoPath;
  final double size;

  const VendorCard({
    super.key,
    required this.logoPath,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: SvgPicture.asset(
          logoPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}