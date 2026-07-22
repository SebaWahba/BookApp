import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/vendor_local_datasource.dart';
import 'package:bookapp/features/vendors/data/datasources/vendor_repository_impl.dart';
import '../../domain/entities/vendor_entity.dart';
import 'package:bookapp/features/vendors/domain/repository/vendor_repository.dart';
import '../../domain/usecases/get_vendors_usecase.dart';

// Data Source
final vendorLocalDataSourceProvider = Provider<VendorLocalDataSource>((ref) {
  return VendorLocalDataSourceImpl();
});

// Repository
final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final dataSource = ref.watch(vendorLocalDataSourceProvider);
  return VendorRepositoryImpl(dataSource);
});

// UseCase
final getVendorsUseCaseProvider = Provider<GetVendorsUseCase>((ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return GetVendorsUseCase(repository);
});

// Category Notifier
class SelectedCategoryNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectCategory(int index) {
    state = index;
  }
}

final selectedCategoryIndexProvider =
    NotifierProvider<SelectedCategoryNotifier, int>(SelectedCategoryNotifier.new);

// Vendors List Provider using UseCase
final vendorsListProvider = FutureProvider<List<VendorEntity>>((ref) async {
  final useCase = ref.watch(getVendorsUseCaseProvider);
  return await useCase();
});