import '../../domain/entities/vendor_entity.dart';
import 'package:bookapp/features/vendors/domain/repository/vendor_repository.dart';
import '../datasources/vendor_local_datasource.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorLocalDataSource localDataSource;

  VendorRepositoryImpl(this.localDataSource);

  @override
  Future<List<VendorEntity>> getVendors() async {
    final models = await localDataSource.getVendors();
    return models
        .map((model) => VendorEntity(
              id: model.id,
              name: model.name,
              imagePath: model.imagePath,
              category: model.category,
              rating: model.rating,
            ))
        .toList();
  }
}