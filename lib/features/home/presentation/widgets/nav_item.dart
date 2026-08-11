import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/extensions/theme_ext.dart';

class NavItem extends StatelessWidget {
  final String activeIcon;
  final String inactiveIcon;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  ? context.type.bodySmallMedium.copyWith(
                color: context.colors.primary,
              )
                  : context.type.bodySmallRegular.copyWith(
                color: context.colors.body,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}