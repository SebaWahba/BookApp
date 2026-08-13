import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/CartItem_repo.dart';
import '../../domain/entities/CartItemEntity.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  // كود الـ Firebase والـ Firestore بيتحط هنا بالكامل بعيداً عن الشاشات
  @override
  Stream<List<CartItemEntity>> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return CartItemModel.fromMap(doc.data(), doc.id);
            }).toList());
  }

  @override
  Future<void> removeFromCart(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(docId)
        .delete();
  }
}