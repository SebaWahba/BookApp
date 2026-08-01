import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/home/domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_datasource.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource remoteDataSource;
  VendorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VendorEntity>> getVendors() async {
    final models = await remoteDataSource.getVendors();
    return models;
  }
}
