import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class BookHeaderSection extends ConsumerStatefulWidget {
  final String title;

  const BookHeaderSection({super.key, required this.title});

  @override
  ConsumerState<BookHeaderSection> createState() => _BookHeaderSectionState();
}

class _BookHeaderSectionState extends ConsumerState<BookHeaderSection> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: AppTextStyles.h4.copyWith(
              color: isDark ? Colors.white : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(16),
        GestureDetector(
          onTap: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isFavorite
                ? SvgPicture.asset(
                    AppAssets.favIconSvg,
                    key: const ValueKey<bool>(true),
                    width: 28,
                    height: 28,
                  )
                : Icon(
                    Icons.favorite_border,
                    key: const ValueKey<bool>(false),
                    color: AppColors.primary600,
                    size: 28,
                  ),
          ),
        ),
      ],
    );
  }
}
