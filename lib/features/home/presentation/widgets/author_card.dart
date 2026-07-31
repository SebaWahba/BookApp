import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class AuthorCard extends ConsumerWidget {
  final String imagePath;
  final String name;
  final String role;
  final double width;

  const AuthorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    this.width = 110.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            width: 102,
            height: 102,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: AppTextStyles.bodyLargeMedium.copyWith(
              color: isDark ? Colors.white : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: isDark ? Colors.white70 : AppColors.grey500,
          ),
        ],
      ),
    );
  }
}