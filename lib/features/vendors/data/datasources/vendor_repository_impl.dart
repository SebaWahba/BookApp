import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/vendors/domain/repository/vendor_repository.dart';
import '../datasources/vendor_local_datasource.dart'; // 

class VendorRepositoryImpl implements VendorRepository {
  final VendorLocalDataSource localDataSource; 
  VendorRepositoryImpl(this.localDataSource);

  @override
  Future<List<VendorEntity>> getVendors() async {
    final models = await localDataSource.getVendors();
    return models;
  }
}