import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../models/notification_order_model.dart';
import 'package:bookapp/features/notifications/domain/entities/notification_order_entity.dart';
class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Stream<List<NotificationOrderEntity>> getOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationOrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .update({'status': 'Cancelled'});
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }
}