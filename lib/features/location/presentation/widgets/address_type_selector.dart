import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class AddressTypeSelector extends StatelessWidget {
  final String title;
  final String homeLabel;
  final String officeLabel;
  final String selectedType; // 'home' or 'office'
  final ValueChanged<String> onTypeSelected;

  const AddressTypeSelector({
    super.key,
    required this.title,
    required this.homeLabel,
    required this.officeLabel,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyles.h6.copyWith(
            fontSize: 16.sp,
            color: AppColors.grey900,
          ),
        ),
        Gap(AppSpacing.sm.h),
        Row(
          children: [
            Expanded(
              child: _TypeTile(
                icon: Icons.home_rounded,
                label: homeLabel,
                isSelected: selectedType.toLowerCase() == 'home',
                onTap: () => onTypeSelected('home'),
              ),
            ),
            Gap(AppSpacing.md.w),
            Expanded(
              child: _TypeTile(
                icon: Icons.work_rounded,
                label: officeLabel,
                isSelected: selectedType.toLowerCase() == 'office',
                onTap: () => onTypeSelected('office'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary500;
    const inactiveBorder = AppColors.grey200;
    const inactiveBg = AppColors.grey50;

    return Material(
      color: isSelected ? AppColors.primary50 : inactiveBg,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? activeColor : inactiveBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.r,
                color: isSelected ? activeColor : AppColors.grey600,
              ),
              Gap(AppSpacing.xs.w),
              Text(
                label,
                style: AppTextStyles.bodyMediumSemiBold.copyWith(
                  color: isSelected ? activeColor : AppColors.grey700,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
