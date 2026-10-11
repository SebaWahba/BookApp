import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';
import 'notification_remote_datasource.dart';

/// Optional developer helper that populates the Firestore `notifications`
/// collection with sample documents matching the UI designs.
///
/// It is NOT used by the app at runtime. Call it once (e.g. temporarily from
/// `main()` after `Firebase.initializeApp()`), then remove the call:
///
/// ```dart
/// await seedNotifications(FirebaseFirestore.instance);
/// ```
///
/// By default it does nothing if the collection already has documents;
/// pass `force: true` to add the samples anyway.
Future<void> seedNotifications(
  FirebaseFirestore firestore, {
  bool force = false,
}) async {
  final collection = firestore.collection(
    NotificationRemoteDataSourceImpl.collectionName,
  );

  if (!force) {
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) return;
  }

  final now = DateTime.now();

  final samples = <NotificationModel>[
    NotificationModel(
      id: '',
      title: 'Your order is on the way',
      body: 'Carrie Fisher is on the way to your address.',
      type: NotificationType.delivery,
      createdAt: now,
      bookTitle: 'Carrie Fisher',
      bookImage: 'https://covers.openlibrary.org/b/isbn/9780399173592-M.jpg',
      itemsCount: 1,
      deliveryStatus: DeliveryStatus.onTheWay,
    ),
    NotificationModel(
      id: '',
      title: 'Your order has been delivered',
      body: 'The Da vinci Code has been delivered.',
      type: NotificationType.delivery,
      createdAt: DateTime(2021, 10, 20, 14, 10),
      isRead: true,
      bookTitle: 'The Da vinci Code',
      bookImage: 'https://covers.openlibrary.org/b/isbn/0385504209-M.jpg',
      itemsCount: 1,
      deliveryStatus: DeliveryStatus.delivered,
    ),
    NotificationModel(
      id: '',
      title: 'Your order has been delivered',
      body: 'Carrie Fisher has been delivered.',
      type: NotificationType.delivery,
      createdAt: DateTime(2021, 10, 12, 9, 45),
      isRead: true,
      bookTitle: 'Carrie Fisher',
      bookImage: 'https://covers.openlibrary.org/b/isbn/9780399173592-M.jpg',
      itemsCount: 5,
      deliveryStatus: DeliveryStatus.delivered,
    ),
    NotificationModel(
      id: '',
      title: 'Your order has been cancelled',
      body: 'The Waiting has been cancelled.',
      type: NotificationType.delivery,
      createdAt: DateTime(2021, 10, 5, 17, 0),
      isRead: true,
      bookTitle: 'The Waiting',
      bookImage: 'https://covers.openlibrary.org/b/isbn/9781250234681-M.jpg',
      itemsCount: 2,
      deliveryStatus: DeliveryStatus.cancelled,
    ),
    NotificationModel(
      id: '',
      title: 'Today 50% discount on all products in Chapter with online orders',
      discountDetails:
          'Today 50% discount on all Books in Novel category with online '
          'orders worldwide.',
      body: 'Excuse me… Who could ever resist a discount feast? 👀\n\n'
          'Hear me out. Today, October 21, 2021, Chapter has a 50% discount '
          'for any product. What are you waiting for, let\'s order now before '
          'it runs out.\n\n'
          'All of the products are discounted, just order through the Chapter '
          'app to enjoy this discount. From the best to the best we have '
          'prepared for you, may you always be happy when ordering at Chapter. '
          'Please choose the best product you want.\n\n'
          'So, what\'s your call? Let\'s roll, order your comfort food now 😉',
      type: NotificationType.promotion,
      createdAt: DateTime(2021, 10, 21, 8, 0),
      bannerImage: 'https://covers.openlibrary.org/b/isbn/9780156012195-L.jpg',
    ),
    NotificationModel(
      id: '',
      title: 'Buy 2 get 1 free',
      discountDetails:
          'Buy 2 get 1 free for since books from 08 - 10 October 2021.',
      body: 'Buy any 2 books and get 1 more for free! Valid from 08 to 10 '
          'October 2021 on all categories, online orders only.',
      type: NotificationType.promotion,
      createdAt: DateTime(2021, 10, 8, 20, 30),
    ),
    NotificationModel(
      id: '',
      title: 'There is a new book now are available',
      body: 'New arrivals just landed in Chapter. Check out the latest books '
          'in your favourite categories.',
      type: NotificationType.information,
      createdAt: DateTime(2021, 9, 16, 11, 0),
      isRead: true,
    ),
  ];

  final batch = firestore.batch();
  for (final notification in samples) {
    batch.set(collection.doc(), notification.toFirestore());
  }
  await batch.commit();
}
