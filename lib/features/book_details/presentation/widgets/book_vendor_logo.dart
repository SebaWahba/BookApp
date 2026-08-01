import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/themes/app_text_styles.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class BookVendorLogo extends StatelessWidget {
  final VendorEntity? vendor;

  const BookVendorLogo({super.key, this.vendor});

  @override
  Widget build(BuildContext context) {
    if (vendor == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: SvgPicture.asset(
        vendor!.imagePath,
        height: 24.h,
        width: 80.w,
        errorBuilder: (_, _, _) => Text(
          vendor!.name,
          style: AppTextStyles.h5.copyWith(color: Colors.deepOrange),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}