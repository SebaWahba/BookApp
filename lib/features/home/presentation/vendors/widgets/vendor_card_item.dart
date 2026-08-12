import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class VendorCardItem extends StatelessWidget {
  final VendorEntity vendor;
  final VoidCallback? onTap;

  const VendorCardItem({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final assetPath = AppAssets.vendorAssetFor(
      id: vendor.id,
      name: vendor.name,
      imagePath: vendor.imagePath,
    );

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
                color: context.colors.surface,
                border: Border.all(color: context.colors.stroke),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    assetPath,
                    width: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.storefront_outlined,
                      color: context.colors.body,
                      size: 28.sp,
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
            style: context.type.bodySmallBold.copyWith(
              color: context.colors.title,
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
                      ? context.colors.warning
                      : context.colors.divider,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}