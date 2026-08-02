import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_assets.dart';
import 'vendor_card.dart';

class VendorsSection extends ConsumerWidget {
  const VendorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendors = [
      AppAssets.vendorWarehouseStationery,
      AppAssets.vendorKuromiSvg,
      AppAssets.vendorGoodaySvg,
      AppAssets.vendorCraneCoSvg,
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