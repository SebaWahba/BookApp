import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/services/notification_service.dart'; // استيراد خدمة الإشعارات

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Notification',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary500,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary500,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMediumBold,
          tabs: const [
            Tab(text: 'Delivery'),
            Tab(text: 'News & Promo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DeliveryNotificationsTab(),
          _NewsPromoNotificationsTab(),
        ],
      ),
    );
  }
}

class _DeliveryNotificationsTab extends ConsumerStatefulWidget {
  const _DeliveryNotificationsTab();

  @override
  ConsumerState<_DeliveryNotificationsTab> createState() => _DeliveryNotificationsTabState();
}

class _DeliveryNotificationsTabState extends ConsumerState<_DeliveryNotificationsTab> {
  // لمانع تكرار الإشعار لنفس الأوردر في نفس الجلسة
  final Set<String> _notifiedOrderIds = {};

  Future<void> _cancelOrder(BuildContext context, String orderId, String bookTitle) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .update({'status': 'Cancelled'});

    await NotificationService.showCancelledNotification(bookTitle);
    
    await Future.delayed(const Duration(milliseconds: 300));

    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          'Please login to see delivery updates',
          style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
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
              'No delivery updates available',
              style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500),
            ),
          );
        }

        final orders = snapshot.data!.docs;
        final now = DateTime.now();

        // فحص الأوردرات أوتوماتيك لو وقتها جه عشان نحولها لـ Delivered ونبعت الإشعار
        for (var doc in orders) {
          final data = doc.data() as Map<String, dynamic>;
          final status = (data['status'] ?? '').toString().trim().toLowerCase();
          final Timestamp? deliveryTimestamp = data['deliveryTime'] as Timestamp?;

          if (deliveryTimestamp != null && status != 'delivered' && status != 'cancelled' && status != 'completed') {
            final deliveryTime = deliveryTimestamp.toDate();
            if (now.isAfter(deliveryTime) && !_notifiedOrderIds.contains(doc.id)) {
              _notifiedOrderIds.add(doc.id);

              // 1. تحديث الحالة في الفايربيز إلى Delivered أوتوماتيك
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('orders')
                  .doc(doc.id)
                  .update({'status': 'Delivered'});

              // 2. استخراج اسم الكتاب لإرساله في الإشعار
              final items = data['items'] as List<dynamic>? ?? [];
              final firstItem = items.isNotEmpty ? items[0] : {};
              final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';

              // 3. إطلاق إشعار الوصول أوتوماتيك
              NotificationService.showDeliveredNotification(title);
            }
          }
        }

        final currentOrders = orders.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = (data['status'] ?? '').toString().trim().toLowerCase();
          
          if (status == 'cancelled' || status == 'delivered' || status == 'completed') {
            return false;
          }

          final Timestamp? deliveryTimestamp = data['deliveryTime'] as Timestamp?;
          if (deliveryTimestamp != null) {
            final deliveryTime = deliveryTimestamp.toDate();
            if (now.isAfter(deliveryTime)) {
              return false;
            }
          }

          return true;
        }).toList();

        final pastOrders = orders.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = (data['status'] ?? '').toString().trim().toLowerCase();
          
          if (status == 'cancelled') return true;
          if (status == 'delivered' || status == 'completed') return true;

          final Timestamp? deliveryTimestamp = data['deliveryTime'] as Timestamp?;
          if (deliveryTimestamp != null) {
            final deliveryTime = deliveryTimestamp.toDate();
            if (now.isAfter(deliveryTime)) {
              return true;
            }
          }

          return false;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (currentOrders.isNotEmpty) ...[
              Text('Current', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
              const SizedBox(height: 12),
              ...currentOrders.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final items = data['items'] as List<dynamic>? ?? [];
                final firstItem = items.isNotEmpty ? items[0] : {};
                
                final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';
                final imageUrl = firstItem['thumbnailUrl'] ?? firstItem['image'] ?? firstItem['imageUrl'] ?? '';
                
                final itemsCount = items.fold<int>(0, (sum, item) {
                  final qty = item['quantity'];
                  return sum + (qty is int ? qty : int.tryParse(qty.toString()) ?? 1);
                });

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey200!),
                  ),
                  child: Column(
                    children: [
                      Padding(
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
                                    style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'On the way',
                                        style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('•  $itemsCount items', style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _cancelOrder(context, doc.id, title),
                            child: Text(
                              'Cancel Order',
                              style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            if (pastOrders.isNotEmpty) ...[
              Text('Order History', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
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
                    
                    final data = doc.data() as Map<String, dynamic>;
                    final items = data['items'] as List<dynamic>? ?? [];
                    final firstItem = items.isNotEmpty ? items[0] : {};
                    
                    final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';
                    final imageUrl = firstItem['thumbnailUrl'] ?? firstItem['image'] ?? firstItem['imageUrl'] ?? '';
                    
                    final itemsCount = items.fold<int>(0, (sum, item) {
                      final qty = item['quantity'];
                      return sum + (qty is int ? qty : int.tryParse(qty.toString()) ?? 1);
                    });

                    final rawStatus = (data['status'] ?? '').toString().trim().toLowerCase();
                    String displayStatus = 'Delivered';
                    Color statusColor = AppColors.green;

                    if (rawStatus == 'cancelled') {
                      displayStatus = 'Cancelled';
                      statusColor = AppColors.red;
                    } else {
                      displayStatus = 'Delivered';
                      statusColor = AppColors.green;
                    }

                    return Column(
                      children: [
                        Padding(
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
                                        errorBuilder: (context, error, stackTrace) => _buildDateChipErrorFallback(), // تم التصحيح لتجنب الخطأ
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
                                      style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          displayStatus,
                                          style: AppTextStyles.bodySmallBold.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('•  $itemsCount items', style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildDateChipErrorFallback() {
    return _buildDefaultBookCover();
  }
}

class _NewsPromoNotificationsTab extends StatelessWidget {
  const _NewsPromoNotificationsTab();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allNotifications = [
      {
        'type': 'Promotion',
        'section': 'Today',
        'dateString': 'Today • 08.00',
        'title': 'Today 50% discount on all Books in Novel category with online orders worldwide.',
        'image': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300',
        'isClickable': true,
      },
      {
        'type': 'Information',
        'section': 'Today',
        'dateString': 'Today • 10.30',
        'title': 'New science fiction collection has just arrived in our main store.',
        'image': 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300',
        'isClickable': false,
      },
      {
        'type': 'Promotion',
        'section': 'Yesterday',
        'dateString': 'Yesterday • 14.15',
        'title': 'Buy 2 get 1 free for all science books from the Chapter collection.',
        'image': 'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=300',
        'isClickable': true,
      },
      {
        'type': 'News',
        'section': 'Yesterday',
        'dateString': 'Yesterday • 18.00',
        'title': 'Chapter app won the best bookstore mobile application award for 2026!',
        'image': 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300',
        'isClickable': false,
      },
      {
        'type': 'Promotion',
        'section': 'Last Week',
        'dateString': 'Last Week • 09.00',
        'title': 'Special weekend bundle: Get 3 bestseller novels with 30% off.',
        'image': 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=300',
        'isClickable': true,
      },
      {
        'type': 'Information',
        'section': 'Last Week',
        'dateString': 'Last Week • 16.45',
        'title': 'Our delivery service is now available in 5 new cities across the country.',
        'image': 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=300',
        'isClickable': false,
      },
    ];

    final todayList = allNotifications.where((item) => item['section'] == 'Today').toList();
    final yesterdayList = allNotifications.where((item) => item['section'] == 'Yesterday').toList();
    final lastWeekList = allNotifications.where((item) => item['section'] == 'Last Week').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (todayList.isNotEmpty) ...[
          Text('Today', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
          const SizedBox(height: 12),
          ...todayList.map((item) => _buildNotificationCard(context, item)),
          const SizedBox(height: 16),
        ],
        if (yesterdayList.isNotEmpty) ...[
          Text('Yesterday', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
          const SizedBox(height: 12),
          ...yesterdayList.map((item) => _buildNotificationCard(context, item)),
          const SizedBox(height: 16),
        ],
        if (lastWeekList.isNotEmpty) ...[
          Text('Last Week', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
          const SizedBox(height: 12),
          ...lastWeekList.map((item) => _buildNotificationCard(context, item)),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> item) {
    final bool isPromo = item['type'] == 'Promotion';
    final bool isClickable = item['isClickable'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: isClickable
            ? () => context.push(AppRoutes.promotionDetail, extra: item)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item['image'],
                  width: 60,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 75,
                    color: AppColors.grey200,
                    child: const Icon(Icons.book, color: AppColors.primary500),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['type'],
                          style: AppTextStyles.bodyMediumBold.copyWith(
                            color: isPromo ? AppColors.primary500 : AppColors.blue,
                          ),
                        ),
                        Text(
                          item['dateString'],
                          style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey400, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'],
                      style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey700, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isClickable) ...[
                const SizedBox(width: 8),
                const Center(
                  child: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grey400),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}