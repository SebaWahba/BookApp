import 'package:flutter/material.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';

class VendorsErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const VendorsErrorState({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.type.bodyMediumMedium.copyWith(color: context.colors.title),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: PrimaryButton(text: retryLabel, onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
