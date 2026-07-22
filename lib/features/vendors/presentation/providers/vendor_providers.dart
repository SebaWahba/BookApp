  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:bookapp/core/network/api_client_provider.dart';
import '../../data/datasources/vendor_local_datasource.dart';
  import 'package:bookapp/features/vendors/data/datasources/vendor_remote_datasource.dart';
  import 'package:bookapp/features/vendors/data/datasources/vendor_repository_impl.dart';
  import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
  import 'package:bookapp/features/vendors/domain/repository/vendor_repository.dart';
  import 'package:bookapp/features/vendors/domain/usecases/get_vendors_usecase.dart';

  final vendorRemoteDataSourceProvider = Provider<VendorRemoteDataSource>((ref) {
    final apiClient = ref.watch(apiClientProvider);
    return VendorRemoteDataSourceImpl(apiClient.dio); 
  });

  final vendorLocalDataSourceProvider = Provider<VendorLocalDataSource>((ref) {
    return VendorLocalDataSourceImpl();
  }); // 👈 ضيفي البروفايدر المحلي هنا

  final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
    final dataSource = ref.watch(vendorLocalDataSourceProvider); // 👈 استعملي المحلي هنا
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
      NotifierProvider<SelectedCategoryNotifier, int>(SelectedCategoryNotifier.new);

  final vendorsListProvider = FutureProvider<List<VendorEntity>>((ref) async {
    final useCase = ref.watch(getVendorsUseCaseProvider);
    return await useCase();
  });