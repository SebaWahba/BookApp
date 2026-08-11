import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class AddressDetailCard extends StatelessWidget {
  final String title;
  final String addressText;
  final bool isLoading;
  final VoidCallback onCurrentLocationPressed;

  const AddressDetailCard({
    super.key,
    required this.title,
    required this.addressText,
    required this.isLoading,
    required this.onCurrentLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.h6.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.grey900,
                ),
              ),
              InkWell(
                onTap: onCurrentLocationPressed,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primary500,
                    size: 20.r,
                  ),
                ),
              ),
            ],
          ),
          Gap(AppSpacing.xs.h),
          if (isLoading)
            Shimmer.fromColors(
              baseColor: AppColors.grey200,
              highlightColor: AppColors.grey100,
              child: Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            )
          else
            Text(
              addressText.isEmpty ? '—' : addressText,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: AppColors.grey600,
                fontSize: 14.sp,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
