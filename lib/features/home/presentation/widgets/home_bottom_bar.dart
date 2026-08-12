import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import '../../../../l10n/app_localizations.dart';
import 'nav_item.dart';

enum BottomNavTab { home, category, cart, profile }

class HomeBottomBar extends StatelessWidget {
  final BottomNavTab currentTab;
  final ValueChanged<BottomNavTab>? onTabTap;

  const HomeBottomBar({super.key, required this.currentTab, this.onTabTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border(
          top: BorderSide(
            color: context.colors.divider,
            width: 1.0,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                activeIcon: AppAssets.navHomeActive,
                inactiveIcon: AppAssets.navHomeInactive,
                iconWidth: 24,
                iconHeight: 24,
                label: l10n.homeTitle,
                isActive: currentTab == BottomNavTab.home,
                onTap: () => onTabTap?.call(BottomNavTab.home),
              ),
              NavItem(
                activeIcon: AppAssets.navCategoryActive,
                inactiveIcon: AppAssets.navCategoryInactive,
                iconWidth: 20,
                iconHeight: 20,
                label: l10n.categoryTitle,
                isActive: currentTab == BottomNavTab.category,
                onTap: () => onTabTap?.call(BottomNavTab.category),
              ),
              NavItem(
                activeIcon: AppAssets.navCartActive,
                inactiveIcon: AppAssets.navCartInactive,
                iconWidth: 24,
                iconHeight: 24,
                label: l10n.cartTitle,
                isActive: currentTab == BottomNavTab.cart,
                onTap: () => onTabTap?.call(BottomNavTab.cart),
              ),
              NavItem(
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
        ),
      ),
    );
  }
}