import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import 'vendor_card.dart';

class VendorsSection extends StatelessWidget {
  const VendorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vendors = [
      AppAssets.vendorWarehouseStationery,
      AppAssets.vendorKuromi,
      AppAssets.vendorGooday,
      AppAssets.vendorCraneCo,
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => VendorCard(logoPath: vendors[index]),
      ),
    );
  }
}