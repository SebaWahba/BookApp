import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';

class AuthorCardItem extends StatelessWidget {
  final AuthorEntity author;
  final VoidCallback? onTap;

  const AuthorCardItem({super.key, required this.author, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: Image.network(
                author.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.vendorCardBackground,
                  child: Center(
                    child: Text(
                      author.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmallBold.copyWith(
                        color: AppColors.vendorTitleText,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            author.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmallBold.copyWith(
              color: AppColors.vendorTitleText,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            author.jobTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.vendorSubtleText,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
