import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/components/buttons/secondary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class BookActionSection extends ConsumerWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String price;
  final VoidCallback onAddToCart; // 1. تعريف البارامتر هنا

  const BookActionSection({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.price,
    required this.onAddToCart, // 2. استقباله في الـ constructor
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Column(
      children: [
        Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E1E)
                : AppColors.vendorCardBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              InkWell(
                onTap: onDecrement,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.grey[800] : AppColors.grey200,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: isDark ? Colors.white70 : AppColors.grey500,
                    size: 18,
                  ),
                ),
              ),
              const Gap(16),
              Text(
                "$quantity",
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: isDark ? Colors.white : null,
                ),
              ),
              const Gap(16),
              InkWell(
                onTap: onIncrement,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary600,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        Text(
          price,
          style: AppTextStyles.h5.copyWith(color: AppColors.primary600),
        ),
      ],
        ),
        const Gap(24),
        Row(
      children: [
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: PrimaryButton(
              text: 'Add to Cart', // أو تقدري تستخدمي l10n لو متوفر عندك للنص
              verticalPadding: 16.0,
              onPressed: onAddToCart, // 3. ربط الزرار بالدالة هنا
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: SecondaryButton(
              text: l10n.viewCart,
              onPressed: () {
                // لو حابة يروح لشاشة السلة مباشرة عند الضغط على زر عرض السلة
                // context.push(AppRoutes.cart);
              },
            ),
          ),
        ),
      ],
        ),
      ],
    );
  }
}