import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import '../../../../l10n/app_localizations.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const HomeTopBar({super.key, this.onSearchTap, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              width: 40,
              height: 40,
              colorFilter: context.isDark
                  ? ColorFilter.mode(context.colors.title, BlendMode.srcIn)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.homeTitle,
            style: context.type.h4.copyWith(color: context.colors.title),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: context.colors.hint,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search books, authors, vendors...',
                      style: context.type.bodyMediumRegular.copyWith(
                        color: context.colors.hint,
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
                  colorFilter: context.isDark
                      ? ColorFilter.mode(context.colors.title, BlendMode.srcIn)
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