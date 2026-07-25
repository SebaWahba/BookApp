import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/themes/app_colors.dart';

class VendorCard extends StatelessWidget {
  final String logoPath;

  const VendorCard({super.key, required this.logoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
        child: SvgPicture.asset(logoPath),
      ),
    );
  }
}
