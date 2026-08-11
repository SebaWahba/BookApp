import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class DeliveryNotificationsView extends StatelessWidget {
  const DeliveryNotificationsView({super.key});

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .update({'status': 'Cancelled'});

    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please login to see notifications'));
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Notification',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary500));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No delivery notifications yet',
                style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          // الطلبات الجارية (Pending أو On the way)
          final currentOrders = orders.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = (data['status'] ?? 'Pending').toString().trim().toLowerCase();
            return status == 'pending' || status == 'on the way';
          }).toList();

          // الطلبات السابقة (Delivered أو Cancelled أو Completed)
          final pastOrders = orders.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = (data['status'] ?? '').toString().trim().toLowerCase();
            return status != 'pending' && status != 'on the way';
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (currentOrders.isNotEmpty) ...[
                Text(
                  'Current',
                  style: AppTextStyles.bodyLargeSemiBold.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...currentOrders.map((doc) => Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey200!),
                  ),
                  child: Column(
                    children: [
                      _buildOrderRow(doc),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _cancelOrder(context, doc.id),
                            child: Text(
                              'Cancel Order',
                              style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              if (pastOrders.isNotEmpty) ...[
                Text(
                  'October 2021', // مطابقة للفيجما
                  style: AppTextStyles.bodyLargeSemiBold.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey200!),
                  ),
                  child: Column(
                    children: pastOrders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final doc = entry.value;
                      final isLast = index == pastOrders.length - 1;
                      return Column(
                        children: [
                          _buildOrderRow(doc),
                          if (!isLast) const Divider(height: 1, color: AppColors.grey200),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderRow(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : {};
    
    // التقاط الاسم بأكثر من احتمال لضمان عدم ظهوره فارغاً
    final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';
    
    // التقاط الصورة بأي اسم ممكن (thumbnailUrl أو image أو imageUrl أو cover)
    final imageUrl = firstItem['thumbnailUrl'] ?? 
                     firstItem['image'] ?? 
                     firstItem['imageUrl'] ?? 
                     firstItem['cover'] ?? '';
    
    final itemsCount = items.fold<int>(0, (sum, item) {
      final qty = item['quantity'];
      return sum + (qty is int ? qty : int.tryParse(qty.toString()) ?? 1);
    });

    final rawStatus = (data['status'] ?? 'Pending').toString().trim();
    final statusLower = rawStatus.toLowerCase();

    String displayStatus = 'On the way';
    Color statusColor = AppColors.blue;

    if (statusLower == 'delivered' || statusLower == 'completed' || statusLower == 'success') {
      displayStatus = 'Delivered';
      statusColor = AppColors.green;
    } else if (statusLower == 'cancelled') {
      displayStatus = 'Cancelled';
      statusColor = AppColors.red;
    } else {
      displayStatus = 'On the way'; // عرض Pending في التطبيق كـ On the way باللون الأزرق المطابق للفيجما
      statusColor = AppColors.blue;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.toString().isNotEmpty
                ? Image.network(
                    imageUrl.toString(),
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildDefaultBookCover(),
                  )
                : _buildDefaultBookCover(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMediumBold.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      displayStatus,
                      style: AppTextStyles.bodySmallBold.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  $itemsCount items',
                      style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBookCover() {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primary500.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, color: AppColors.primary500, size: 28),
      ),
    );
  }
}