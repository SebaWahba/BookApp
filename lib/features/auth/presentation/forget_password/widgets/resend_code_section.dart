import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../providers/forget_password_notifier.dart';

class ResendCodeSection extends ConsumerWidget {
  const ResendCodeSection({super.key, required this.onResend});

  /// Expected to re-issue a code; the notifier restarts the countdown itself.
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgetPasswordProvider);
    final canResend = !state.isTimerRunning && !state.isLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.resendText,
          style: context.type.bodyLargeRegular.copyWith(
            color: context.colors.body,
          ),
        ),
        const SizedBox(width: 6),
        if (!canResend)
          Text(
            state.isTimerRunning
                ? '${l10n.resendButton} (${state.countdownSeconds}s)'
                : l10n.resendButton,
            style: context.type.bodyLargeMedium.copyWith(
              color: context.colors.hint,
            ),
          )
        else
          GestureDetector(
            onTap: onResend,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
              child: Text(
                l10n.resendButton,
                style: context.type.bodyLargeMedium.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}