import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.createdAt,
    super.isRead,
    super.bookTitle,
    super.bookImage,
    super.itemsCount,
    super.deliveryStatus,
    super.bannerImage,
    super.discountDetails,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? const {};

    return NotificationModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: _parseType(data['type']),
      createdAt: _parseDate(data['createdAt']),
      isRead: data['isRead'] as bool? ?? false,
      bookTitle: data['bookTitle'] as String?,
      bookImage: data['bookImage'] as String?,
      itemsCount: (data['itemsCount'] as num?)?.toInt(),
      deliveryStatus: _parseStatus(data['deliveryStatus']),
      bannerImage: data['bannerImage'] as String?,
      discountDetails: data['discountDetails'] as String?,
    );
  }

  /// Serialises to a Firestore document. `id` is the document id and is
  /// therefore not stored as a field; null optionals are omitted.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      if (bookTitle != null) 'bookTitle': bookTitle,
      if (bookImage != null) 'bookImage': bookImage,
      if (itemsCount != null) 'itemsCount': itemsCount,
      if (deliveryStatus != null) 'deliveryStatus': deliveryStatus!.name,
      if (bannerImage != null) 'bannerImage': bannerImage,
      if (discountDetails != null) 'discountDetails': discountDetails,
    };
  }

  static NotificationType _parseType(Object? value) {
    return NotificationType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => NotificationType.information,
    );
  }

  static DeliveryStatus? _parseStatus(Object? value) {
    for (final status in DeliveryStatus.values) {
      if (status.name == value) return status;
    }
    return null;
  }

  static DateTime _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }
}
