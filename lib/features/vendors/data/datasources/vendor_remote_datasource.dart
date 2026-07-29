import 'package:bookapp/config/app_assets.dart';
import 'package:dio/dio.dart';

import '../models/vendor_models.dart';

abstract class VendorRemoteDataSource {
  Future<List<VendorModel>> getVendors();
}

class VendorRemoteDataSourceImpl implements VendorRemoteDataSource {
  final Dio dio;

  VendorRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VendorModel>> getVendors() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final List<Map<String, dynamic>> fakeJsonResponse = [
      {
        'id': '1',
        'name': 'Wattpad',
        'image': AppAssets.vendorWattpadSvg,
        'category': 'Books',
        'rating': 4,
      },
      {
        'id': '2',
        'name': 'Kuromi',
        'image': AppAssets.vendorKuromiSvg,
        'category': 'Stationery',
        'rating': 5,
      },
      {
        'id': '3',
        'name': 'Crane & Co',
        'image': AppAssets.vendorCraneCoSvg,
        'category': 'Books',
        'rating': 4,
      },
      {
        'id': '4',
        'name': 'GooDay',
        'image': AppAssets.vendorGoodaySvg,
        'category': 'Poems',
        'rating': 4,
      },
      {
        'id': '5',
        'name': 'Warehouse',
        'image': AppAssets.vendorWarehouseStationery,
        'category': 'Stationery',
        'rating': 4,
      },
      {
        'id': '6',
        'name': 'Peppa Pig',
        'image': AppAssets.vendorPippaPigSvg,
        'category': 'Special for you',
        'rating': 4,
      },
      {
        'id': '7',
        'name': 'Jstor',
        'image': AppAssets.vendorJstorSvg,
        'category': 'Books',
        'rating': 4,
      },
      {
        'id': '8',
        'name': 'Peloton',
        'image': AppAssets.vendorPelotongSvg,
        'category': 'Special for you',
        'rating': 4,
      },
      {
        'id': '9',
        'name': 'Haymarket',
        'image': AppAssets.vendorHSvg,
        'category': 'Poems',
        'rating': 4,
      },
    ];

    return fakeJsonResponse.map((json) => VendorModel.fromJson(json)).toList();
  }
}
