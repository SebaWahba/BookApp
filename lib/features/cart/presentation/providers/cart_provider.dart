import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// جلب عناصر السلة لحظياً من Firestore
final cartItemsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // حفظ الـ Document ID للتحكم في الحذف أو التعديل
            return data;
          }).toList());
});

// حساب إجمالي عدد العناصر للـ Badge في الـ AppBar
final cartItemCountProvider = StreamProvider<int>((ref) {
  final cartAsync = ref.watch(cartItemsProvider);
  return cartAsync.when(
    data: (items) {
      int count = 0;
      for (var item in items) {
        count += (item['quantity'] ?? 1) as int;
      }
      return Stream.value(count);
    },
    loading: () => Stream.value(0),
    error: (_, __) => Stream.value(0),
  );
});

// جلب عدد الإشعارات غير المقروءة لحظياً
final unreadNotificationsProvider = StreamProvider<int>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});