import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../l10n/app_localizations.dart';

class SpecialOfferBanner extends StatelessWidget {
  const SpecialOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 375,
      height: 165,
      color: AppColors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 1,
            left: 228,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowGrey.withValues(alpha: 0.2),
                    offset: const Offset(0, 15.68),
                    blurRadius: 31.35,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.14),
                child: Image.asset(
                  AppAssets.specialOffer,
                  width: 99,
                  height: 145,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 24,
            child: SizedBox(
              width: 327,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.specialOfferTitle, style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    l10n.specialOfferSubtitle,
                    style: AppTextStyles.bodyMediumRegular,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 118,
                    child: PrimaryButton(
                      text: l10n.orderNowButton,
                      onPressed: () {},
                      verticalPadding: 8.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary500,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.primary100,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.primary100,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}