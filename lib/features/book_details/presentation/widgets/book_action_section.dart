import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/components/buttons/secondary_button.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import '../../../../l10n/app_localizations.dart';

class BookActionSection extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String price;

  const BookActionSection({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
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
                        color: context.colors.divider,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: context.colors.body,
                        size: 18,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "$quantity",
                    style: context.type.bodyLargeMedium.copyWith(
                      color: context.colors.title,
                    ),
                  ),
                  const Gap(16),
                  InkWell(
                    onTap: onIncrement,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.primary,
                      ),
                      child: Icon(
                        Icons.add,
                        color: context.colors.onPrimary,
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
              style: context.type.h5.copyWith(color: context.colors.primary),
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
                  text: l10n.continueShopping,
                  verticalPadding: 16.0,
                  onPressed: () {},
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SecondaryButton(text: l10n.viewCart, onPressed: () {}),
              ),
            ),
          ],
        ),
      ],
    );
  }
}