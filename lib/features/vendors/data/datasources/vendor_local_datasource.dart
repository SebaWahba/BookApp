import '../models/vendor_models.dart';

abstract class VendorLocalDataSource {
  Future<List<VendorModel>> getVendors();
}

class VendorLocalDataSourceImpl implements VendorLocalDataSource {
  @override
  Future<List<VendorModel>> getVendors() async {
    return const [
      VendorModel(
        id: '1',
        name: 'Wattpad',
        imagePath: 'assets/images/wattpad.png',
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '2',
        name: 'Kuromi',
        imagePath: 'assets/images/kuromi.png',
        category: 'Stationery',
        rating: 5,
      ),
      VendorModel(
        id: '3',
        name: 'Crane & Co',
        imagePath: 'assets/images/crane&co.png',
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '4',
        name: 'GooDay',
        imagePath: 'assets/images/GooDay.png',
        category: 'Poems',
        rating: 4,
      ),
      VendorModel(
        id: '5',
        name: 'Warehouse',
        imagePath: 'assets/images/warehouse.png',
        category: 'Stationery',
        rating: 4,
      ),
      VendorModel(
        id: '6',
        name: 'Peppa Pig',
        imagePath: 'assets/images/peppa.png',
        category: 'Special for you',
        rating: 4,
      ),
      VendorModel(
        id: '7',
        name: 'Jstor',
        imagePath: 'assets/images/jstor.png',
        category: 'Books',
        rating: 4,
      ),
      VendorModel(
        id: '8',
        name: 'Peloton',
        imagePath: 'assets/images/peloton.png',
        category: 'Special for you',
        rating: 4,
      ),
      VendorModel(
        id: '9',
        name: 'Haymarket',
        imagePath: 'assets/images/H.png',
        category: 'Poems',
        rating: 4,
      ),
    ];
  }
}