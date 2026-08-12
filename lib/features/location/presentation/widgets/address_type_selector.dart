import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class AddressTypeSelector extends StatelessWidget {
  const AddressTypeSelector({
    super.key,
    required this.homeLabel,
    required this.officeLabel,
    required this.selectedType,
    required this.onChanged,
  });

  final String homeLabel;
  final String officeLabel;
  final String selectedType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AddressTypeOption(
            icon: Icons.home_rounded,
            label: homeLabel,
            isSelected: selectedType == 'home',
            onTap: () => onChanged('home'),
          ),
        ),
        Gap(AppSpacing.sm.w),
        Expanded(
          child: _AddressTypeOption(
            icon: Icons.work_rounded,
            label: officeLabel,
            isSelected: selectedType == 'office',
            onTap: () => onChanged('office'),
          ),
        ),
      ],
    );
  }
}

class _AddressTypeOption extends StatelessWidget {
  const _AddressTypeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary500 : AppColors.grey600;

    return Material(
      color: isSelected ? AppColors.primary50 : AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 58.h),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primary500 : AppColors.grey200,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20.r),
              Gap(AppSpacing.xs.w),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMediumSemiBold.copyWith(
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
