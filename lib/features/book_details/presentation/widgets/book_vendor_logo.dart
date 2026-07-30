import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/themes/app_text_styles.dart';
import '../../../vendors/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class BookVendorLogo extends ConsumerWidget {
  final VendorEntity? vendor;

  const BookVendorLogo({super.key, this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (vendor == null) return const SizedBox.shrink();

    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SvgPicture.asset(
        vendor!.imagePath,
        height: 24,
        width: 80,
        errorBuilder: (_, _, _) => Text(
          vendor!.name,
          style: AppTextStyles.h5.copyWith(
            color: isDark ? Colors.deepOrangeAccent : Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}