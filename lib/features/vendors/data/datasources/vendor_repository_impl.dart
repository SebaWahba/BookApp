import 'package:bookapp/features/vendors/data/datasources/vendor_remote_datasource.dart';
import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/vendors/domain/repository/vendor_repository.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource remoteDataSource;

  VendorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VendorEntity>> getVendors() async {
    final models = await remoteDataSource.getVendors();
    return models;
  }
}