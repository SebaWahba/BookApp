import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import '../providers/order_history_providers.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderHistoryStreamProvider);
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 800.0 : double.infinity;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.title),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Order History',
          style: context.type.h4.copyWith(color: context.colors.title, fontSize: 18.sp),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'No order history found',
                      style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  children: [
                    Text(
                      'Activity',
                      style: context.type.bodyMediumBold.copyWith(
                        color: context.colors.title,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...orders.map((order) {
                      final isDelivered = order.status == 'Delivered';

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: context.colors.stroke),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                order.imageUrl,
                                width: 50.w,
                                height: 65.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 50.w,
                                  height: 65.h,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.book, color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.title,
                                    style: context.type.bodyMediumBold.copyWith(
                                      color: context.colors.title,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDelivered ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        order.status,
                                        style: context.type.bodySmallRegular.copyWith(
                                          color: isDelivered ? Colors.green : Colors.red,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '•  ${order.itemsCount} items',
                                        style: context.type.bodySmallRegular.copyWith(
                                          color: context.colors.body,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ),
      ),
    );
  }
}