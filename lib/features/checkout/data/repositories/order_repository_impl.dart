import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/order_repositories.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_models.dart';

class OrderRepositoryImpl implements OrderRepository {
  
  @override
  Future<String> createOrder({
    required List<dynamic> items,
    required double subtotal,
    required double shipping,
    required double total,
    required String paymentMethod,
    required String dateTime,
    required DateTime deliveryTime,
    required String address,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // 1. حفظ الطلب في كوليكشن orders
    final orderRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add({
      'items': items,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
      'paymentMethod': paymentMethod,
      'dateTime': dateTime,
      'deliveryTime': Timestamp.fromDate(deliveryTime),
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'On the way',
    });

    // 2. مسح السلة بعد إتمام الطلب بنجاح
    final cartDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    for (var doc in cartDocs.docs) {
      await doc.reference.delete();
    }

    return orderRef.id; // نرجع الـ ID عشان نعرضه في شاشة النجاح
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .get();

    if (!doc.exists) throw Exception('Order not found');
    return OrderModel.fromMap(doc.data()!, doc.id);
  }
}