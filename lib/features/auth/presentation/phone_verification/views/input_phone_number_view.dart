import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/app_assets.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/components/inputs/app_text_field.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../config/themes/app_colors.dart';
import '../providers/phone_verification_provider.dart';

class InputPhoneNumberView extends ConsumerStatefulWidget {
  const InputPhoneNumberView({super.key});

  @override
  ConsumerState<InputPhoneNumberView> createState() => _InputPhoneNumberViewState();
}

class _InputPhoneNumberViewState extends ConsumerState<InputPhoneNumberView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }
    ref.read(phoneVerificationProvider.notifier).sendCode(_phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneVerificationProvider);
    final isLoading = state.status == PhoneVerificationStatus.loading;

    ref.listen(phoneVerificationProvider, (previous, next) {
      if (next.status == PhoneVerificationStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
      // TODO: if success, navigate to verification screen
    });

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Phone Number', style: AppTextStyles.h3, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Please enter your phone number, so we can more easily deliver your order',
              style: AppTextStyles.bodyLargeRegular.copyWith(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Phone Number', style: AppTextStyles.bodyMediumMedium),
            ),
            SizedBox(height: AppSpacing.xs),
            AppTextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  AppAssets.call,
                  width: 19,
                  height: 19,
                  colorFilter: const ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: isLoading ? 'Sending...' : 'Continue',
              onPressed: isLoading ? () {} : _onContinuePressed,
            ),
          ],
        ),
      ),
    );
  }
}