import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  static const String collectionName = 'notifications';

  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final snapshot = await firestore
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(NotificationModel.fromFirestore).toList();
  }
}
