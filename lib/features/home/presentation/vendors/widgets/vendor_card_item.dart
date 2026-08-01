import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class VendorCardItem extends StatelessWidget {
  final VendorEntity vendor;
  final VoidCallback? onTap;

  const VendorCardItem({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.vendorCardBackground,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.network(
                    vendor.imagePath,
                    fit: BoxFit.cover,
                    placeholderBuilder: (context) => Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            vendor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmallBold.copyWith(
              color: AppColors.vendorTitleText,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: List.generate(
              5,
                  (index) => Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.star_rounded,
                  size: 12.sp,
                  color: index < vendor.rating
                      ? AppColors.starRating
                      : AppColors.vendorTitleText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
