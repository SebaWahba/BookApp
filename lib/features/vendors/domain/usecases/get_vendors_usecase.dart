import '../entities/vendor_entity.dart';
import '../repository/vendor_repository.dart';

class GetVendorsUseCase {
  final VendorRepository repository;

  GetVendorsUseCase(this.repository);

  Future<List<VendorEntity>> call() async {
    return await repository.getVendors();
  }
}