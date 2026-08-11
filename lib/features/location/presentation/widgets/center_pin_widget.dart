import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/themes/app_colors.dart';

class CenterPinWidget extends StatelessWidget {
  final bool isMoving;

  const CenterPinWidget({
    super.key,
    this.isMoving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, isMoving ? -10.h : 0, 0),
          child: Icon(
            Icons.location_on_rounded,
            size: 44.r,
            color: AppColors.primary500,
          ),
        ),
        Container(
          width: 8.r,
          height: 4.r,
          decoration: BoxDecoration(
            color: AppColors.grey800.withValues(alpha: 0.3),
            borderRadius: BorderRadius.all(Radius.elliptical(8.r, 4.r)),
          ),
        ),
      ],
    );
  }
}
