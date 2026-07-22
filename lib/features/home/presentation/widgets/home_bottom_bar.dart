import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

enum BottomNavTab { home, category, cart, profile }

class HomeBottomBar extends StatelessWidget {
  final BottomNavTab currentTab;
  final ValueChanged<BottomNavTab>? onTabTap;

  const HomeBottomBar({
    super.key,
    required this.currentTab,
    this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 83,
      padding: const EdgeInsets.only(top: 4, right: 24, bottom: 4, left: 24),
      color: AppColors.grey50,
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
          _NavItem(
            activeIcon: AppAssets.navCategoryActive,
            inactiveIcon: AppAssets.navCategoryInactive,
            iconWidth: 18,
            iconHeight: 20,
            label: l10n.categoryTitle,
            isActive: currentTab == BottomNavTab.category,
            onTap: () => onTabTap?.call(BottomNavTab.category),
          ),
          _NavItem(
            activeIcon: AppAssets.navCartActive,
            inactiveIcon: AppAssets.navCartInactive,
            iconWidth: 24,
            iconHeight: 24,
            label: l10n.cartTitle,
            isActive: currentTab == BottomNavTab.cart,
            onTap: () => onTabTap?.call(BottomNavTab.cart),
          ),
          _NavItem(
            activeIcon: AppAssets.navProfileActive,
            inactiveIcon: AppAssets.navProfileInactive,
            iconWidth: 24,
            iconHeight: 24,
            label: l10n.profileTitle,
            isActive: currentTab == BottomNavTab.profile,
            onTap: () => onTabTap?.call(BottomNavTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                ? AppTextStyles.bodySmallMedium.copyWith(color: AppColors.primary500)
                : AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}