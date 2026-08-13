import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookapp/l10n/app_localizations.dart';

import '../../../../../config/app_assets.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/components/inputs/phone_number_field.dart';
import '../../../../../core/enums/verification_status.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/extensions/theme_ext.dart';
import '../../../../../core/responsive/app_breakpoints.dart';
import '../../../../../core/utils/regex_validators.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../providers/phone_verification_notifier.dart';
import '../../providers/auth_notifier.dart';

typedef PhoneVerifiedCallback = void Function(String phone);

class InputPhoneNumberView extends ConsumerStatefulWidget {
  const InputPhoneNumberView({super.key, required this.onVerified});

  final PhoneVerifiedCallback onVerified;

  @override
  ConsumerState<InputPhoneNumberView> createState() =>
      _InputPhoneNumberViewState();
}

class _InputPhoneNumberViewState extends ConsumerState<InputPhoneNumberView> {
  final _phoneController = TextEditingController();
  String _selectedCountryCode = CountryDialCode.supported.first.dialCode;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinuePressed() async {
    FocusScope.of(context).unfocus();

    final l10n = AppLocalizations.of(context)!;
    final rawPhone = _phoneController.text.trim();

    if (rawPhone.isEmpty) {
      SnackbarUtils.showError(context, l10n.valPhoneEmpty);
      return;
    }

    // Composed through the shared field so forgot-password looks the number up
    // in exactly the form it is stored in.
    final fullPhoneNumber = PhoneNumberField.compose(
      _selectedCountryCode,
      rawPhone,
    );

    if (!RegexValidators.isPhoneNumber(fullPhoneNumber)) {
      SnackbarUtils.showError(context, l10n.valPhoneInvalid);
      return;
    }

    try {

      await ref
          .read(authProvider.notifier)
          .saveUserPhoneNumber(phone: fullPhoneNumber);

      if (!mounted) return;

      final authState = ref.read(authProvider);
      if (authState.errorMessage != null) {
        SnackbarUtils.showError(context, authState.errorMessage!);
        return;
      }


      widget.onVerified(fullPhoneNumber);
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(
        context,
        l10n.resetPasswordFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneVerificationProvider);
    final authState = ref.watch(authProvider);
    final isLoading =
        state.status == PhoneVerificationStatus.loading || authState.isLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: BackButton(color: context.colors.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayoutWidths.maxFormWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    l10n.phoneNumberTitle,
                    style: AppTextStyles.h3.copyWith(color: context.colors.title),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.phoneNumberSubtitle,
                    style: AppTextStyles.bodyLargeRegular.copyWith(
                      color: context.colors.hint,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.contactMethodPhoneTitle,
                      style: AppTextStyles.bodyMediumMedium.copyWith(color: context.colors.title),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  PhoneNumberField(
                    controller: _phoneController,
                    dialCode: _selectedCountryCode,
                    onDialCodeChanged: (value) =>
                        setState(() => _selectedCountryCode = value),
                    hintText: "1001234567",
                    enabled: !isLoading,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset(
                        AppAssets.call,
                        width: 19.w,
                        height: 19.h,
                        colorFilter: ColorFilter.mode(
                          context.colors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    text: isLoading ? l10n.sendingButton : l10n.continueButton,
                    onPressed: isLoading ? null : _onContinuePressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
