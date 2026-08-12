import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class AuthorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final double width;
  final VoidCallback? onTap;

  const AuthorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    this.width = 110.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  color: AppColors.vendorCardBackground,
                  child: Center(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmallBold.copyWith(
                        color: AppColors.vendorTitleText,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTextStyles.bodyLargeMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: AppColors.grey500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
