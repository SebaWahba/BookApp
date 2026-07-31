import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

enum BottomNavTab { home, category, cart, profile }

class HomeBottomBar extends ConsumerWidget {
  final BottomNavTab currentTab;
  final ValueChanged<BottomNavTab>? onTabTap;

  const HomeBottomBar({super.key, required this.currentTab, this.onTabTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Container(
      height: 70,
      width: double.infinity,
      height: 83,
      padding: const EdgeInsets.only(top: 4, right: 24, bottom: 4, left: 24),
      color: isDark ? Colors.black : AppColors.grey50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            activeIcon: AppAssets.navHomeActive,
            inactiveIcon: AppAssets.navHomeInactive,
            iconWidth: 24,
            iconHeight: 25.5,
            label: l10n.homeTitle,
            isActive: currentTab == BottomNavTab.home,
            onTap: () => onTabTap?.call(BottomNavTab.home),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final String activeIcon;
  final String inactiveIcon;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isActive ? activeIcon : inactiveIcon,
            width: iconWidth,
            height: iconHeight,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: isActive
                ? AppTextStyles.bodySmallMedium.copyWith(
                    color: AppColors.primary500,
                  )
                : AppTextStyles.bodySmallRegular.copyWith(
                    color: isDark ? Colors.white70 : AppColors.grey500,
                  ),
          ),
        ),
      ),
    );
  }
}