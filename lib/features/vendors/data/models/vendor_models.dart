class VendorModel {
  final String id;
  final String name;
  final String imagePath;
  final String category;
  final int rating;

  const VendorModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.rating,
  });
}

final List<VendorModel> dummyVendors = [
  const VendorModel(
    id: '1',
    name: 'Wattpad',
    imagePath: 'assets/images/wattpad.png',
    category: 'Books',
    rating: 4,
  ),
  const VendorModel(
    id: '2',
    name: 'Kuromi',
    imagePath: 'assets/images/kuromi.png',
    category: 'Stationery',
    rating: 5,
  ),
  const VendorModel(
    id: '3',
    name: 'Crane & Co',
    imagePath: 'assets/images/crane&co.png',
    category: 'Books',
    rating: 4,
  ),
  const VendorModel(
    id: '4',
    name: 'GooDay',
    imagePath: 'assets/images/GooDay.png',
    category: 'Poems',
    rating: 4,
  ),
  const VendorModel(
    id: '5',
    name: 'Warehouse',
    imagePath: 'assets/images/warehouse.png',
    category: 'Stationery',
    rating: 4,
  ),
  const VendorModel(
    id: '6',
    name: 'Peppa Pig',
    imagePath: 'assets/images/peppa.png',
    category: 'Special for you',
    rating: 4,
  ),
  const VendorModel(
    id: '7',
    name: 'Jstor',
    imagePath: 'assets/images/jstor.png',
    category: 'Books',
    rating: 4,
  ),
  const VendorModel(
    id: '8',
    name: 'Peloton',
    imagePath: 'assets/images/peloton.png',
    category: 'Special for you',
    rating: 4,
  ),
  const VendorModel(
    id: '9',
    name: 'Haymarket',
    imagePath: 'assets/images/H.png',
    category: 'Poems',
    rating: 4,
  ),
];