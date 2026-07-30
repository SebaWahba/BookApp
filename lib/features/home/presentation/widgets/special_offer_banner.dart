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
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 340;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.specialOfferTitle,
                          style: isNarrow
                              ? AppTextStyles.h5
                              : AppTextStyles.h4,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.specialOfferSubtitle,
                          style: AppTextStyles.bodyMediumRegular.copyWith(
                            color: AppColors.grey600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 120,
                          child: PrimaryButton(
                            text: l10n.orderNowButton,
                            onPressed: () {},
                            verticalPadding: 8.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      AppAssets.specialOffer,
                      width: isNarrow ? 70 : 90,
                      height: isNarrow ? 100 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          );
        },
      ),
    );
  }
}