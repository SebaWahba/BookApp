import '../entities/vendor_entity.dart';
import 'package:bookapp/features/home/domain/repositories/vendor_repository.dart';

class GetVendorsUseCase {
  final VendorRepository repository;

  GetVendorsUseCase(this.repository);

  Future<List<VendorEntity>> call() async {
    return await repository.getVendors();
  }
}
