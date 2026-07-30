import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class BookHeaderSection extends StatefulWidget {
  final String title;

  const BookHeaderSection({super.key, required this.title});

  @override
  State<BookHeaderSection> createState() => _BookHeaderSectionState();
}

class _BookHeaderSectionState extends State<BookHeaderSection> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: AppTextStyles.h4,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Gap(16.w),
        GestureDetector(
          onTap: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isFavorite
                ? SvgPicture.asset(
              AppAssets.favIconSvg,
              key: const ValueKey<bool>(true),
              width: 28.w,
              height: 28.h,
            )
                : Icon(
              Icons.favorite_border,
              key: const ValueKey<bool>(false),
              color: AppColors.primary600,
              size: 28.sp,
            ),
          ),
        ),
      ],
    );
  }
}