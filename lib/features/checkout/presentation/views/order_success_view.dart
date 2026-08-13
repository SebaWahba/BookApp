import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookapp/features/checkout/presentation/providers/order_provider.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/checkout/presentation/providers/order_provider.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class OrderSuccessView extends ConsumerWidget {
  const OrderSuccessView({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    // استدعاء البروفايدر الجديد المعتمد على Clean Architecture لجلب تفاصيل الأوردر
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: user == null
          ? Center(child: Text(l10n.pleaseLogin))
          : orderAsync.when(
              data: (order) {
                final items = order.items;
                final subtotal = order.subtotal;
                final shipping = order.shipping;
                final total = order.total;
                final dateTime = order.dateTime;

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        // Top Success Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary500.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${l10n.thankYou} ',
                                    style: AppTextStyles.bodyLargeSemiBold.copyWith(
                                      color: AppColors.grey900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text('👋', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.successOrderTitle,
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  height: 1.35,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Order #$orderId',
                                style: AppTextStyles.bodyMediumMedium.copyWith(
                                  color: AppColors.grey500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Cancel Order Row -> navigates to Home
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.cancelQuestion,
                              style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go(AppRoutes.home);
                              },
                              child: Text(
                                l10n.cancel,
                                style: AppTextStyles.bodySmallBold.copyWith(
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Order Details Heading
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.orderDetails,
                            style: AppTextStyles.bodyLargeSemiBold.copyWith(
                              color: AppColors.grey900,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Order Details Card with automatic title wrapping
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.grey200!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...items.map((item) {
                                final title = item['title'] ?? 'Book';
                                final qty = item['quantity'] ?? 1;
                                final price = ((item['price'] ?? 0.0).toDouble() * qty).toStringAsFixed(2);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${qty}x   $title',
                                          style: AppTextStyles.bodyMediumRegular.copyWith(
                                            color: AppColors.grey900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '\$$price',
                                        style: AppTextStyles.bodyMediumRegular.copyWith(
                                          color: AppColors.grey900,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(color: AppColors.grey200, thickness: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.subtotal,
                                    style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900),
                                  ),
                                  Text(
                                    '\$${subtotal.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.shipping,
                                    style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900),
                                  ),
                                  Text(
                                    '\$${shipping.toStringAsFixed(0)}',
                                    style: AppTextStyles.bodyMediumBold.copyWith(
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(color: AppColors.grey200, thickness: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.totalPayment,
                                    style: AppTextStyles.bodyLargeSemiBold.copyWith(
                                      color: AppColors.grey900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${total.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodyLargeSemiBold.copyWith(
                                      color: AppColors.primary500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.deliveryIn,
                                    style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey900),
                                  ),
                                  Text(
                                    l10n.deliveryTimeValue,
                                    style: AppTextStyles.bodyMediumRegular.copyWith(
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.time,
                                    style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey900),
                                  ),
                                  Text(
                                    dateTime,
                                    style: AppTextStyles.bodyMediumRegular.copyWith(
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Order Status Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500.withOpacity(0.08),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              context.push(AppRoutes.orderFeedback, extra: orderId);
                            },
                            child: Text(
                              l10n.orderStatus,
                              style: AppTextStyles.bodyLargeSemiBold.copyWith(
                                color: AppColors.primary500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
    );
  }
}