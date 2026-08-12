import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. بروفايدر يراقب حالة تسجيل الدخول لحظياً (Login / Logout)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 2. بروفايدر السلة اللي بيحدث نفسه تلقائياً أول ما اليوزر يسجل دخول
final cartItemsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  // بنعمل watch لحالة الـ Auth عشان أول ما تحصل غراستة دخول، الـ Provider يعيد بناء نفسه فوراً
  final authState = ref.watch(authStateChangesProvider);
  
  final user = authState.value ?? FirebaseAuth.instance.currentUser;
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
final cartItemCountProvider = Provider<int>((ref) {
  final cartAsync = ref.watch(cartItemsProvider);
  return cartAsync.maybeWhen(
    data: (items) => items.fold<int>(
      0,
      (sum, item) => sum + ((item['quantity'] as num?)?.toInt() ?? 1),
    ),
    orElse: () => 0,
  );
});

// جلب عدد الإشعارات غير المقروءة لحظياً
final unreadNotificationsProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final user = authState.value ?? FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});