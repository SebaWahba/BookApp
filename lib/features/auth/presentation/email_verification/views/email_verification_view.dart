import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/presentation/providers/email_verification_notifier.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/buttons/primary_button.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback? onVerified;

  const EmailVerificationView({
    super.key,
    required this.email,
    this.onVerified,
  });

  @override
  ConsumerState<EmailVerificationView> createState() =>
      _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.email.isNotEmpty) {
        ref.read(emailVerificationProvider.notifier).resendCode(widget.email);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _enteredCode {
    return _controllers.map((c) => c.text).join();
  }

  void _verify() {
    final code = _enteredCode;
    if (code.length == 4) {
      ref
          .read(emailVerificationProvider.notifier)
          .verifyCode(widget.email, code);
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDemoCodeBottomSheet(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.mark_email_unread_rounded,
                size: 48,
                color: AppColors.primary500,
              ),
              const SizedBox(height: 12),
              Text('Random Verification Code', style: AppTextStyles.h5),
              const SizedBox(height: 8),
              Text(
                'Here is your randomly generated verification code to proceed:',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: AppColors.primary500,
                        size: 20,
                      ),
                      tooltip: 'Copy code',
                      onPressed: () => _copyCode(code),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Got it',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EmailVerificationState>(emailVerificationProvider, (
      previous,
      next,
    ) {
      if (next.status == EmailVerificationStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'An error occurred'),
            backgroundColor: AppColors.red,
          ),
        );
      } else if (next.status == EmailVerificationStatus.success) {
        if (previous?.status != EmailVerificationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Verified successfully!'),
              backgroundColor: AppColors.green,
            ),
          );

          if (widget.onVerified != null && context.mounted) {
            widget.onVerified!();
          }
        }
      } else if (next.status == EmailVerificationStatus.resendSuccess &&
          previous?.status != EmailVerificationStatus.resendSuccess) {
        _showDemoCodeBottomSheet(next.code ?? "1234");
      }
    });

    final state = ref.watch(emailVerificationProvider);
    final isEmail = widget.email.contains('@');

    final displayContact = widget.email.isNotEmpty
        ? widget.email
        : 'your account';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                isEmail ? 'Verification Email' : 'Phone Verification',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),
              Text(
                isEmail
                    ? 'Please enter the code we just sent to email\n$displayContact'
                    : 'Please enter the code we just sent to phone\n$displayContact',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _focusNodes[index].hasFocus
                            ? AppColors.primary500
                            : AppColors.grey300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_enteredCode.length == 4) {
                          _verify();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you didn't receive a code? ",
                    style: AppTextStyles.bodyMediumRegular.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  GestureDetector(
                    onTap: state.status == EmailVerificationStatus.loading
                        ? null
                        : () {
                            if (widget.email.isNotEmpty) {
                              ref
                                  .read(emailVerificationProvider.notifier)
                                  .resendCode(widget.email);
                            }
                          },
                    child: Text(
                      'Resend',
                      style: AppTextStyles.bodyMediumRegular.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              PrimaryButton(
                text: 'Continue',
                minHeight: 55,
                onPressed: state.status == EmailVerificationStatus.loading
                    ? null
                    : _verify,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
