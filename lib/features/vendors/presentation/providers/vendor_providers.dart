import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/vendor_local_datasource.dart';
import '../../data/models/vendor_models.dart';


final vendorLocalDataSourceProvider = Provider<VendorLocalDataSource>((ref) {
  return VendorLocalDataSourceImpl();
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

// Vendors List Provider
final vendorsListProvider = FutureProvider<List<VendorModel>>((ref) async {
  final dataSource = ref.watch(vendorLocalDataSourceProvider);
  return await dataSource.getVendors();
});