import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/services/notification_service.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:bookapp/features/notifications/presentation/providers/notifications_provider.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.grey50,
      appBar: AppBar(
        title: Text(
          l10n.notifications,
          style: AppTextStyles.h4.copyWith(
            color: isDark ? Colors.white : AppColors.grey900,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary500,
          unselectedLabelColor: isDark ? Colors.grey[400] : AppColors.grey500,
          indicatorColor: AppColors.primary500,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMediumBold,
          tabs: [
            Tab(text: l10n.deliveryTab),
            Tab(text: l10n.newsPromoTab),
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
  final Set<String> _notifiedOrderIds = {};

  Future<void> _cancelOrder(WidgetRef ref, BuildContext context, String orderId, String bookTitle) async {
    final l10n = AppLocalizations.of(context)!;
    
    final cancelOrderUseCase = ref.read(cancelOrderUseCaseProvider);
    await cancelOrderUseCase(orderId);

    await NotificationService.showCancelledNotification(
      title: l10n.pushOrderCancelledTitle,
      body: l10n.pushOrderCancelledBody(bookTitle),
    );
    
    await Future.delayed(const Duration(milliseconds: 300));

    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return notificationsAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return Center(
            child: Text(
              l10n.noDeliveryUpdates,
              style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500),
            ),
          );
        }

        final now = DateTime.now();
        final user = FirebaseAuth.instance.currentUser;

        for (var order in orders) {
          final status = order.status.trim().toLowerCase();
          if (order.deliveryTime != null && 
              status != 'delivered' && 
              status != 'cancelled' && 
              status != 'completed' &&
              now.isAfter(order.deliveryTime!) && 
              !_notifiedOrderIds.contains(order.id)) {
            
            _notifiedOrderIds.add(order.id);

            if (user != null) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('orders')
                  .doc(order.id)
                  .update({'status': 'Delivered'});
            }

            final items = order.items;
            final firstItem = items.isNotEmpty ? items[0] : {};
            final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';

            NotificationService.showDeliveredNotification(
              title: l10n.pushOrderDeliveredTitle,
              body: l10n.pushOrderDeliveredBody(title),
            );
          }
        }

        final currentOrders = orders.where((order) {
          final status = order.status.trim().toLowerCase();
          
          if (status == 'cancelled' || status == 'delivered' || status == 'completed') {
            return false;
          }

          if (order.deliveryTime != null) {
            if (now.isAfter(order.deliveryTime!)) {
              return false;
            }
          }

          return true;
        }).toList();

        final pastOrders = orders.where((order) {
          final status = order.status.trim().toLowerCase();
          
          if (status == 'cancelled') return true;
          if (status == 'delivered' || status == 'completed') return true;

          if (order.deliveryTime != null) {
            if (now.isAfter(order.deliveryTime!)) {
              return true;
            }
          }

          return false;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (currentOrders.isNotEmpty) ...[
              Text(l10n.currentOrders, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
              const SizedBox(height: 12),
              ...currentOrders.map((order) {
                final items = order.items;
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
                    color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
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
                                      errorBuilder: (context, error, stackTrace) => _buildDefaultBookCover(isDark),
                                    )
                                  : _buildDefaultBookCover(isDark),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: AppTextStyles.bodyMediumBold.copyWith(color: isDark ? Colors.white : AppColors.grey900, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.onTheWayStatus,
                                        style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('•  $itemsCount ${l10n.itemsLabel}', style: AppTextStyles.bodySmallRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500)),
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
                            onPressed: () => _cancelOrder(ref, context, order.id, title),
                            child: Text(
                              l10n.cancelOrderBtn,
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
              Text(l10n.orderHistory, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
                ),
                child: Column(
                  children: pastOrders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    final isLast = index == pastOrders.length - 1;
                    
                    final items = order.items;
                    final firstItem = items.isNotEmpty ? items[0] : {};
                    final title = firstItem['title'] ?? firstItem['name'] ?? 'Book Title';
                    final imageUrl = firstItem['thumbnailUrl'] ?? firstItem['image'] ?? firstItem['imageUrl'] ?? '';
                    
                    final itemsCount = items.fold<int>(0, (sum, item) {
                      final qty = item['quantity'];
                      return sum + (qty is int ? qty : int.tryParse(qty.toString()) ?? 1);
                    });

                    final rawStatus = order.status.trim().toLowerCase();
                    String displayStatus = l10n.deliveredStatus;
                    Color statusColor = AppColors.green;

                    if (rawStatus == 'cancelled') {
                      displayStatus = l10n.cancelledStatus;
                      statusColor = AppColors.red;
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
                                        errorBuilder: (context, error, stackTrace) => _buildDefaultBookCover(isDark),
                                      )
                                    : _buildDefaultBookCover(isDark),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: AppTextStyles.bodyMediumBold.copyWith(color: isDark ? Colors.white : AppColors.grey900, fontWeight: FontWeight.bold),
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
                                        Text('•  $itemsCount ${l10n.itemsLabel}', style: AppTextStyles.bodySmallRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) Divider(height: 1, color: isDark ? Colors.grey[800] : AppColors.grey200),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
      error: (e, s) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? Colors.white : Colors.black))),
    );
  }

  Widget _buildDefaultBookCover(bool isDark) {
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

class _NewsPromoNotificationsTab extends StatelessWidget {
  const _NewsPromoNotificationsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Text(l10n.todaySection, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
          const SizedBox(height: 12),
          ...todayList.map((item) => _buildNotificationCard(context, item, isDark)),
          const SizedBox(height: 16),
        ],
        if (yesterdayList.isNotEmpty) ...[
          Text(l10n.yesterdaySection, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
          const SizedBox(height: 12),
          ...yesterdayList.map((item) => _buildNotificationCard(context, item, isDark)),
          const SizedBox(height: 16),
        ],
        if (lastWeekList.isNotEmpty) ...[
          Text(l10n.lastWeekSection, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
          const SizedBox(height: 12),
          ...lastWeekList.map((item) => _buildNotificationCard(context, item, isDark)),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> item, bool isDark) {
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
            color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
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
                    color: isDark ? Colors.grey[800] : AppColors.grey200,
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
                      style: AppTextStyles.bodySmallRegular.copyWith(color: isDark ? Colors.grey[300] : AppColors.grey700, height: 1.4),
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