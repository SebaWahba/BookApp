import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/app_assets.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class BookVendorLogo extends StatelessWidget {
  final VendorEntity? vendor;

  const BookVendorLogo({super.key, this.vendor});

  @override
  Widget build(BuildContext context) {
    if (vendor == null) return const SizedBox.shrink();

    final assetPath = AppAssets.vendorAssetFor(
      id: vendor!.id,
      name: vendor!.name,
      imagePath: vendor!.imagePath,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SvgPicture.asset(
        assetPath,
        height: 24,
        width: 80,
        placeholderBuilder: (_) => Text(
          vendor!.name,
          style: context.type.h5.copyWith(color: context.colors.primary),
        ),
      ),
    );
  }
}