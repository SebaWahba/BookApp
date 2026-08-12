import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
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
  final VoidCallback? onAddToCart;
  final bool isLoading;

  const BookActionSection({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.price,
    required this.onAddToCart,
    this.isLoading = false,
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
                    onTap: quantity > 1 ? onDecrement : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: quantity > 1 
                            ? (isDark ? Colors.grey[800] : AppColors.grey200)
                            : Colors.transparent,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: quantity > 1 
                            ? (isDark ? Colors.white70 : AppColors.grey500) 
                            : AppColors.grey400,
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
            // الزر الرئيسي (أضف إلى السلة) يظهر على اليمين في واجهات الـ RTL
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: PrimaryButton(
                  text: isLoading ? '...' : l10n.addToCart,
                  verticalPadding: 16.0,
                  onPressed: isLoading ? null : onAddToCart,
                ),
              ),
            ),
            const Gap(16),
            // زر عرض السلة يظهر على اليسار
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SecondaryButton(
                  text: l10n.viewCart,
                  onPressed: () {
                    context.push(AppRoutes.cart);
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