import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../providers/forget_password_notifier.dart';

class ResendCodeSection extends ConsumerWidget {
  const ResendCodeSection({super.key, required this.onResend});

  final VoidCallback onResend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgetPasswordProvider);
    final isTimerRunning = state.isTimerRunning;
    final countdown = state.countdownSeconds;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.resendText,
          style: AppTextStyles.bodyLargeRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(width: 6),
        if (isTimerRunning)
          Text(
            '${l10n.resendButton} (${countdown}s)',
            style: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.grey400,
            ),
          )
        else
          GestureDetector(
            onTap: () {
              onResend();
              ref.read(forgetPasswordProvider.notifier).startResendTimer();
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              child: Text(
                l10n.resendButton,
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
