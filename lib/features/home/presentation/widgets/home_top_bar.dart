import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1024;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSearchTap,
            child: SvgPicture.asset(
              AppAssets.searchIcon,
              width: 36,
              height: 36,
              colorFilter: isDark
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.homeTitle,
            style: AppTextStyles.h4.copyWith(
              color: isDark ? Colors.white : null,
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.grey400, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Search books, authors, vendors...',
                      style: AppTextStyles.bodyMediumRegular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            const Spacer(),
          const SizedBox(width: 12),
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