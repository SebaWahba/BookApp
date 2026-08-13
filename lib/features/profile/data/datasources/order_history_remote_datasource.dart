import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

abstract class OrderHistoryRemoteDataSource {
  Stream<List<OrderModel>> getOrdersStream();
}

class OrderHistoryRemoteDataSourceImpl implements OrderHistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  OrderHistoryRemoteDataSourceImpl(this.firestore, this.auth);

  @override
  Stream<List<OrderModel>> getOrdersStream() {
    final user = auth.currentUser;
    if (user == null) return Stream.value([]);

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final rawStatus = data['status'] ?? data['orderStatus'] ?? 'Delivered';
        
        // تمرير الـ doc.id أولاً ثم الـ map ليتطابق مع تعريف OrderModel.fromMap[cite: 5]
        return OrderModel.fromMap(doc.id, {
          ...data,
          'status': rawStatus,
        });
      }).where((order) {
        final statusLower = order.status.toLowerCase().trim();
        
        // جلب Delivered و Cancelled فقط لا غير
        return statusLower == 'delivered' || statusLower == 'cancelled';
      }).toList();
    });
  }
}