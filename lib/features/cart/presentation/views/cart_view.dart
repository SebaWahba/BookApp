import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/cart/presentation/providers/cart_provider.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  Future<void> _removeItem(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.grey50,
      appBar: AppBar(
        title: Text(l10n.myCart, style: AppTextStyles.h4.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notifications),
                    child: SvgPicture.asset(
                      AppAssets.bellIcon,
                      width: 24,
                      height: 24,
                      colorFilter: isDark ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: SvgPicture.asset(
                      AppAssets.ellipseIcon,
                      width: 8,
                      height: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: cartItemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.navCartInactive,
                    width: 90,
                    height: 90,
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.grey[400]! : AppColors.grey400,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noProducts,
                    style: AppTextStyles.bodyLargeMedium.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500),
                  ),
                ],
              ),
            );
          }

          double subtotal = items.fold(0.0, (sum, item) {
            double price = (item['price'] ?? 0).toDouble();
            int quantity = (item['quantity'] ?? 1);
            return sum + (price * quantity);
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final docId = item['id'];
                    final int quantity = item['quantity'] ?? 1;
                    final double price = (item['price'] ?? 0).toDouble();
                    final double itemTotal = price * quantity;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item['thumbnailUrl'] != null && item['thumbnailUrl'].toString().isNotEmpty
                                ? Image.network(
                                    item['thumbnailUrl'],
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 80,
                                      color: isDark ? Colors.grey[800] : AppColors.grey200,
                                      child: Icon(Icons.book, color: isDark ? Colors.grey[400] : AppColors.grey500),
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 80,
                                    color: isDark ? Colors.grey[800] : AppColors.grey200,
                                    child: Icon(Icons.book, color: isDark ? Colors.grey[400] : AppColors.grey500),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? 'No Title',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMediumBold.copyWith(color: isDark ? Colors.white : AppColors.grey900),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${l10n.quantityLabel}: $quantity',
                                  style: AppTextStyles.bodySmallRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${itemTotal.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.primary500),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.red),
                            onPressed: () => _removeItem(docId),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: isDark ? Colors.black.withOpacity(0.5) : Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.subtotal, style: AppTextStyles.bodyLargeRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500)),
                        Text('\$${subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: isDark ? Colors.white : AppColors.grey900)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.push(AppRoutes.confirmOrder);
                        },
                        child: Text(
                          l10n.proceedToCheckout,
                          style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (error, stack) => Center(child: Text('Error: $error', style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.red))),
      ),
    );
  }
}