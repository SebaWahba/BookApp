import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.title,
    required super.status,
    required super.itemsCount,
    required super.imageUrl,
    required super.dateGroup,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    final items = data['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] as Map<String, dynamic>? ?? {} : {};
    
    String status = data['status'] ?? 'Delivered';
    if (status.toLowerCase() == 'delivered') {
      status = 'Delivered';
    } else if (status.toLowerCase() == 'cancelled') {
      status = 'Cancelled';
    }

    // إضافة thumbnailUrl كأول وأهم احتمال لجلب صورة الكتاب الحقيقية
    final realBookImage = firstItem['thumbnailUrl'] ?? 
                          firstItem['imageUrl'] ?? 
                          firstItem['coverUrl'] ?? 
                          firstItem['thumbnail'] ?? 
                          firstItem['image'] ?? 
                          'https://images.unsplash.com/photo-1544947950-fa07a98d237f';

    return OrderModel(
      id: id,
      title: firstItem['title'] ?? firstItem['name'] ?? 'Book Order',
      status: status,
      itemsCount: items.length,
      imageUrl: realBookImage,
      dateGroup: data['dateGroup'] ?? 'Recent Orders',
    );
  }
}