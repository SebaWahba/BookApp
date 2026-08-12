import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/core/theme/theme_providers.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleTile extends ConsumerWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final mode = ref.watch(themeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: context.colors.primarySurface,
          radius: 20.r,
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            size: 24.sp,
            color: context.colors.primary,
          ),
        ),
        Gap(AppSpacing.lg.w),
        Text(
          l10n.darkModeLabel,
          style: context.type.bodyLargeMedium.copyWith(
            color: context.colors.title,
          ),
        ),
        const Spacer(),
        Switch(
          value: isDark,
          onChanged: (_) => ref
              .read(themeModeProvider.notifier)
              .toggle(platformBrightness: platformBrightness),
        ),
      ],
    );
  }
}