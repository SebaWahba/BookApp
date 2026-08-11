import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class OrderSuccessView extends ConsumerWidget {
  const OrderSuccessView({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: user == null
          ? const Center(child: Text('Please login'))
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('orders')
                  .doc(orderId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary500));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Order not found'));
                }

                final orderData = snapshot.data!.data() as Map<String, dynamic>;
                final items = orderData['items'] as List<dynamic>? ?? [];
                final subtotal = (orderData['subtotal'] ?? 0.0).toDouble();
                final shipping = (orderData['shipping'] ?? 2.0).toDouble();
                final total = (orderData['total'] ?? subtotal + shipping).toDouble();
                final dateTime = orderData['dateTime'] ?? '15.24 - 15.39';

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
                                    'Thank you ',
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
                                'Your order has been placed successfully',
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
                              'Do you want to cancel your order? ',
                              style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go(AppRoutes.home);
                              },
                              child: Text(
                                'Cancel',
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
                            'Order Details',
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
                                    'Subtotal',
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
                                    'Shipping',
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
                                    'Total Payment',
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
                                    'Delivery in',
                                    style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey900),
                                  ),
                                  Text(
                                    '10 - 15 mins',
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
                                    'Time',
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
                              'Order Status',
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
            ),
    );
  }
}