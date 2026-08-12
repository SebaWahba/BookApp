import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.category,
    required super.rating,
  });

  factory VendorModel.fromJson(String id, Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? '';
    final imagePath = json['image']?.toString();

    return VendorModel(
      id: id,
      name: name,
      imagePath: AppAssets.vendorAssetFor(
        id: id,
        name: name,
        imagePath: imagePath,
      ),
      category: _categoryFor(
        id: id,
        name: name,
        fallback: json['category']?.toString(),
      ),
      rating: (json['rating'] as num?)?.toInt() ?? 4,
    );
  }

  static List<VendorModel> get localVendors => const [
    VendorModel(
      id: 'warehouse_stationery',
      name: 'Warehouse Stationery',
      imagePath: AppAssets.vendorWarehouseStationery,
      category: 'Stationery',
      rating: 4,
    ),
    VendorModel(
      id: 'kuromi',
      name: 'Kuromi',
      imagePath: AppAssets.vendorKuromiSvg,
      category: 'Special for you',
      rating: 4,
    ),
    VendorModel(
      id: 'gooday',
      name: 'Gooday',
      imagePath: AppAssets.vendorGoodaySvg,
      category: 'Poems',
      rating: 4,
    ),
    VendorModel(
      id: 'crane_co',
      name: 'Crane Co.',
      imagePath: AppAssets.vendorCraneCoSvg,
      category: 'Stationery',
      rating: 4,
    ),
    VendorModel(
      id: 'pippa_pig',
      name: 'Pippa Pig',
      imagePath: AppAssets.vendorPippaPigSvg,
      category: 'Books',
      rating: 4,
    ),
    VendorModel(
      id: 'peloton',
      name: 'Peloton',
      imagePath: AppAssets.vendorPelotongSvg,
      category: 'Special for you',
      rating: 4,
    ),
    VendorModel(
      id: 'wattpad',
      name: 'Wattpad',
      imagePath: AppAssets.vendorWattpadSvg,
      category: 'Books',
      rating: 4,
    ),
    VendorModel(
      id: 'jstor',
      name: 'JSTOR',
      imagePath: AppAssets.vendorJstorSvg,
      category: 'Books',
      rating: 4,
    ),
    VendorModel(
      id: 'h',
      name: 'H',
      imagePath: AppAssets.vendorHSvg,
      category: 'Poems',
      rating: 4,
    ),
  ];

  static String _categoryFor({
    required String id,
    required String name,
    String? fallback,
  }) {
    final localCategory =
        _categoriesByVendorKey[_normalize(id)] ??
        _categoriesByVendorKey[_normalize(name)];
    if (localCategory != null) return localCategory;

    final category = fallback?.trim();
    return category == null || category.isEmpty ? 'Books' : category;
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static const Map<String, String> _categoriesByVendorKey = {
    'warehouse': 'Stationery',
    'warehousestationery': 'Stationery',
    'warehousestationary': 'Stationery',
    'kuromi': 'Special for you',
    'gooday': 'Poems',
    'goodday': 'Poems',
    'crane': 'Stationery',
    'craneco': 'Stationery',
    'pippa': 'Books',
    'pippapig': 'Books',
    'peppapig': 'Books',
    'peloton': 'Special for you',
    'wattpad': 'Books',
    'jstor': 'Books',
    'h': 'Poems',
  };
}
