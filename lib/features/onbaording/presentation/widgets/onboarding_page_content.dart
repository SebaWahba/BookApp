import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../auth/presentation/providers/theme_provider.dart';

class OnboardingPageContent extends ConsumerWidget {
  final OnbaordingModel model;
  const OnboardingPageContent({required this.model, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: ResponsiveBuilder(
        mobile: (context) => _MobileContent(model: model, isDark: isDark),
        tablet: (context) => _TabletContent(model: model, isDark: isDark),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  final OnbaordingModel model;
  final bool isDark;
  const _MobileContent({required this.model, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: SvgPicture.asset(model.imagePath),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    model.title,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark ? Colors.white : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    model.description,
                    style: AppTextStyles.bodyLargeRegular.copyWith(
                      color: isDark ? Colors.white70 : AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabletContent extends StatelessWidget {
  final OnbaordingModel model;
  final bool isDark;
  const _TabletContent({required this.model, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final isShort = constraints.maxHeight < 320;
        final imageFlex = isNarrow ? 3 : 5;
        final textFlex = isNarrow ? 5 : 4;

        final titleStyle = (isShort
            ? AppTextStyles.h3.copyWith(
          fontSize: (AppTextStyles.h3.fontSize ?? 20) * 0.85,
        )
            : AppTextStyles.h3)
            .copyWith(color: isDark ? Colors.white : null);

        final descStyle = AppTextStyles.bodyLargeRegular.copyWith(
          color: isDark ? Colors.white70 : AppColors.grey500,
          fontSize: isShort
              ? (AppTextStyles.bodyLargeRegular.fontSize ?? 16) * 0.85
              : AppTextStyles.bodyLargeRegular.fontSize,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: imageFlex,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SvgPicture.asset(model.imagePath),
              ),
            ),
            SizedBox(width: isShort ? AppSpacing.md : AppSpacing.xl),
            Expanded(
              flex: textFlex,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.title,
                      style: titleStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isShort ? AppSpacing.md : AppSpacing.xl),
                    Text(
                      model.description,
                      style: descStyle,
                      maxLines: isShort ? 3 : 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}