import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart'; // تأكدي من مسار الـ provider الصحيح
import 'nav_item.dart';

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

    // جلب عدد المنتجات في السلة لحظياً
    final cartCountAsync = ref.watch(cartItemCountProvider);
   
final cartCount = ref.watch(cartItemCountProvider);

    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : AppColors.grey50,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : AppColors.grey200,
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
              // تغليف أيقونة السلة بـ Badge ليعرض عدد العناصر
              Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: NavItem(
                  activeIcon: AppAssets.navCartActive,
                  inactiveIcon: AppAssets.navCartInactive,
                  iconWidth: 24,
                  iconHeight: 24,
                  label: l10n.cartTitle,
                  isActive: currentTab == BottomNavTab.cart,
                  onTap: () => onTabTap?.call(BottomNavTab.cart),
                ),
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