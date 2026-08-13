import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import '../../../../l10n/app_localizations.dart';

class SpecialOfferBanner extends StatelessWidget {
  const SpecialOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 165,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 16,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        offset: const Offset(0, 6),
                        blurRadius: 12,
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
            ),
            Positioned(
              top: 16,
              left: 24,
              child: SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.specialOfferTitle,
                      style: context.type.h4.copyWith(color: context.colors.title),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.specialOfferSubtitle,
                      style: context.type.bodyMediumRegular.copyWith(color: context.colors.title),
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
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colors.divider,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colors.divider,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}