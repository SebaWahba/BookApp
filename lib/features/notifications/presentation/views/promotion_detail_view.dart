import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class PromotionDetailView extends StatelessWidget {
  const PromotionDetailView({super.key, this.promoData});
  final Map<String, dynamic>? promoData;

  @override
  Widget build(BuildContext context) {
    final title = promoData?['title'] ?? 'Today 50% discount on all products in Chapter with online orders';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      appBar: AppBar(
        title: Text(
          'Promotion',
          style: AppTextStyles.h4.copyWith(
            color: isDark ? Colors.white : AppColors.grey900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.notifications);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : AppColors.grey50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '50% Discount\nOn All Desert',
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Grab itu now!',
                            style: AppTextStyles.bodySmallRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () => context.push(AppRoutes.allBooks),
                            child: Text(
                              'Order Now',
                              style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300',
                        width: 110,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 110,
                          height: 140,
                          color: isDark ? Colors.grey[800] : AppColors.grey200,
                          child: const Icon(Icons.book, size: 48, color: AppColors.primary500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: AppTextStyles.bodyLargeSemiBold.copyWith(
                  color: isDark ? Colors.white : AppColors.grey900,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Excuse me... Who could ever resist a discount feast? 👀',
                style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.grey[300] : AppColors.grey700),
              ),
              const SizedBox(height: 16),
              Text(
                'Hear me out. Today, October 21, 2021, Chapter has a 50% discount for any product. What are you waiting for, let\'s order now before it runs out.',
                style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey600, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                'All of the products are discounted, just order through the Chapter app to enjoy this discount. From the best to the best we have prepared for you, may you always be happy when ordering at Chapter. Please choose the best product you want.',
                style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey600, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                'So, what\'s your call? Let\'s roll, order your comfort food now 😉',
                style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey600, height: 1.5),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}