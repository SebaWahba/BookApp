import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const HomeTopBar({super.key, this.onSearchTap, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onSearchTap,
            child: SvgPicture.asset(
              AppAssets.searchIcon,
              width: 40,
              height: 40,
              colorFilter: isDark
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null,
            ),
          ),
          Text(
            l10n.homeTitle,
            style: AppTextStyles.h4.copyWith(
              color: isDark ? Colors.white : null,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: onNotificationTap,
                child: SvgPicture.asset(
                  AppAssets.bellIcon,
                  width: 24,
                  height: 24,
                  colorFilter: isDark
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : null,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: SvgPicture.asset(
                  AppAssets.ellipseIcon,
                  width: 8,
                  height: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}