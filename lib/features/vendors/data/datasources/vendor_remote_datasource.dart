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
      {'id': '1', 'name': 'Wattpad', 'image': 'assets/images/wattpad.png', 'category': 'Books', 'rating': 4},
      {'id': '2', 'name': 'Kuromi', 'image': 'assets/images/kuromi.png', 'category': 'Stationery', 'rating': 5},
      {'id': '3', 'name': 'Crane & Co', 'image': 'assets/images/crane&co.png', 'category': 'Books', 'rating': 4},
      {'id': '4', 'name': 'GooDay', 'image': 'assets/images/GooDay.png', 'category': 'Poems', 'rating': 4},
      {'id': '5', 'name': 'Warehouse', 'image': 'assets/images/warehouse.png', 'category': 'Stationery', 'rating': 4},
      {'id': '6', 'name': 'Peppa Pig', 'image': 'assets/images/peppa.png', 'category': 'Special for you', 'rating': 4},
      {'id': '7', 'name': 'Jstor', 'image': 'assets/images/jstor.png', 'category': 'Books', 'rating': 4},
      {'id': '8', 'name': 'Peloton', 'image': 'assets/images/peloton.png', 'category': 'Special for you', 'rating': 4},
      {'id': '9', 'name': 'Haymarket', 'image': 'assets/images/H.png', 'category': 'Poems', 'rating': 4},
    ];

    return fakeJsonResponse
        .map((json) => VendorModel.fromJson(json))
        .toList();
  }
}