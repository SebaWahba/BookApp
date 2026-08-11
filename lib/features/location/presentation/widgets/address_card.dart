import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/address_entity.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.title,
    this.onTap,
  });

  final AddressEntity address;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.lg.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowGrey.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary50,
                child: Icon(
                  address.addressType == 'office'
                      ? Icons.work_rounded
                      : Icons.home_rounded,
                  color: AppColors.primary500,
                  size: 22.r,
                ),
              ),
              SizedBox(width: AppSpacing.lg.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      address.address,
                      style: AppTextStyles.bodyMediumRegular.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.edit_rounded,
                color: AppColors.grey500,
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
