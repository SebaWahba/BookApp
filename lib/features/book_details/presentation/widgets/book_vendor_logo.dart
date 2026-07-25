import 'package:flutter/material.dart';

import '../../../../config/themes/app_text_styles.dart';
import '../../../vendors/domain/entities/vendor_entity.dart';

class BookVendorLogo extends StatelessWidget {
  final VendorEntity? vendor;

  const BookVendorLogo({super.key, this.vendor});

  @override
  Widget build(BuildContext context) {
    if (vendor == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Image.asset(
        vendor!.imagePath,
        height: 70,
        width: 80,
        errorBuilder: (_, _, _) => Text(
          vendor!.name,
          style: AppTextStyles.h5.copyWith(color: Colors.deepOrange),
        ),
      ),
    );
  }
}
