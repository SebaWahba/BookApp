import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../core/theme/extensions/theme_ext.dart';

class VendorCard extends StatelessWidget {
  final String logoPath;
  final String vendorId;
  final String vendorName;
  final double size;

  const VendorCard({
    super.key,
    required this.logoPath,
    required this.vendorId,
    required this.vendorName,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = AppAssets.vendorAssetFor(
      id: vendorId,
      name: vendorName,
      imagePath: logoPath,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.stroke),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.storefront_outlined,
            color: context.colors.body,
          ),
        ),
      ),
    );
  }
}