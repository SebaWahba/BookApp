import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/home/domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_datasource.dart';
import '../models/vendor_models.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource remoteDataSource;
  VendorRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VendorEntity>> getVendors() async {
    List<VendorModel> models;
    try {
      models = await remoteDataSource.getVendors();
    } catch (_) {
      return VendorModel.localVendors;
    }

    final vendorsByKey = {
      for (final vendor in VendorModel.localVendors) _vendorKey(vendor): vendor,
    };

    for (final model in models) {
      vendorsByKey.putIfAbsent(_vendorKey(model), () => model);
    }

    return vendorsByKey.values.toList();
  }

  String _vendorKey(VendorEntity vendor) {
    final value = vendor.name.isNotEmpty ? vendor.name : vendor.id;
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
