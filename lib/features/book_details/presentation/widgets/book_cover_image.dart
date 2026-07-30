import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/themes/app_colors.dart';

class BookCoverImage extends StatelessWidget {
  final String coverUrl;

  const BookCoverImage({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: coverUrl.isEmpty
            ? Container(
                width: 237.w,
                height: 313.h,
                color: AppColors.grey200,
                child: Icon(Icons.book, size: 64.sp, color: AppColors.grey500),
              )
            : Image.network(
                coverUrl,
                width: 237.w,
                height: 313.h,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 237.w,
                  height: 313.h,
                  color: AppColors.grey200,
                  child: Icon(
                    Icons.book,
                    size: 64.sp,
                    color: AppColors.grey500,
                  ),
                ),
              ),
      ),
    );
  }
}
