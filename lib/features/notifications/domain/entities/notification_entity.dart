enum NotificationType { delivery, promotion, information }

enum DeliveryStatus { onTheWay, delivered, cancelled }

/// A single in-app notification.
///
/// Delivery notifications use [bookTitle], [bookImage], [itemsCount] and
/// [deliveryStatus]; promotion / information notifications use
/// [bannerImage] and [discountDetails]. All type-specific fields are optional.
class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  final String? bookTitle;
  final String? bookImage;
  final int? itemsCount;
  final DeliveryStatus? deliveryStatus;
  final String? bannerImage;
  final String? discountDetails;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.bookTitle,
    this.bookImage,
    this.itemsCount,
    this.deliveryStatus,
    this.bannerImage,
    this.discountDetails,
  });
}
