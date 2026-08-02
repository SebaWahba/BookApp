import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/core/network/firestore_provider.dart';
import 'package:bookapp/features/home/data/datasources/vendor_remote_datasource.dart';
import 'package:bookapp/features/home/data/repositories/vendor_repository_impl.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/home/domain/repositories/vendor_repository.dart';
import 'package:bookapp/features/home/domain/usecases/get_vendors_usecase.dart';

final vendorRemoteDataSourceProvider = Provider<VendorRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return VendorRemoteDataSourceImpl(firestore);
});

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final dataSource = ref.watch(vendorRemoteDataSourceProvider);
  return VendorRepositoryImpl(dataSource);
});

final getVendorsUseCaseProvider = Provider<GetVendorsUseCase>((ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return GetVendorsUseCase(repository);
});

class SelectedCategoryNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectCategory(int index) {
    state = index;
  }
}

final selectedCategoryIndexProvider =
    NotifierProvider<SelectedCategoryNotifier, int>(
      SelectedCategoryNotifier.new,
    );

final vendorsListProvider = FutureProvider<List<VendorEntity>>((ref) async {
  final useCase = ref.watch(getVendorsUseCaseProvider);
  return await useCase();
});
