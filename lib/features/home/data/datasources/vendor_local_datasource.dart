import 'package:bookapp/config/app_assets.dart';

import '../models/vendor_models.dart';

abstract class VendorLocalDataSource {
  Future<List<VendorModel>> getVendors();
}

class VendorLocalDataSourceImpl implements VendorLocalDataSource {
  @override
  Future<List<VendorModel>> getVendors() async {
    return const [
      VendorModel(
        id: '1',
        name: 'Wattpad',
        imagePath: AppAssets.vendorWattpadSvg,
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '2',
        name: 'Kuromi',
        imagePath: AppAssets.vendorKuromiSvg,
        category: 'Stationery',
        rating: 5,
      ),
      VendorModel(
        id: '3',
        name: 'Crane & Co',
        imagePath: AppAssets.vendorCraneCoSvg,
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '4',
        name: 'GooDay',
        imagePath: AppAssets.vendorGoodaySvg,
        category: 'Poems',
        rating: 4,
      ),
      VendorModel(
        id: '5',
        name: 'Warehouse',
        imagePath: AppAssets.vendorWarehouseStationery,
        category: 'Stationery',
        rating: 4,
      ),
      VendorModel(
        id: '6',
        name: 'Peppa Pig',
        imagePath: AppAssets.vendorPippaPigSvg,
        category: 'Special for you',
        rating: 4,
      ),
      VendorModel(
        id: '7',
        name: 'Jstor',
        imagePath: AppAssets.vendorJstorSvg,
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '8',
        name: 'Peloton',
        imagePath: AppAssets.vendorPelotongSvg,
        category: 'Special for you',
        rating: 4,
      ),
      VendorModel(
        id: '9',
        name: 'Haymarket',
        imagePath: AppAssets.vendorHSvg,
        category: 'Poems',
        rating: 4,
      ),
    ];
  }
}
