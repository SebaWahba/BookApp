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
    final response = await dio.get('/vendors');

    if (response.data != null) {
      final List<dynamic> items = response.data['items'] ?? response.data;
      return items
          .map((json) => VendorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}