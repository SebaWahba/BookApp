import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primarySurface,
            radius: 20.r,
            child: Icon(icon, size: 24.sp),
          ),
          Gap(AppSpacing.lg.w),
          Text(
            title,
            style: context.type.bodyLargeMedium.copyWith(
              color: context.colors.title,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: context.colors.body,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}