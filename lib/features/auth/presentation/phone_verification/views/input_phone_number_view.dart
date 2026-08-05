import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookapp/l10n/app_localizations.dart';

import '../../../../../config/app_assets.dart';
import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/components/inputs/app_text_field.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/enums/verification_status.dart';
import '../../../../../core/responsive/app_breakpoints.dart';
import '../../../../../core/utils/regex_validators.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../providers/phone_verification_notifier.dart';
import '../../providers/auth_notifier.dart'; // استدعاء الـ authProvider لحفظ الرقم

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
  String _selectedCountryCode = '+20';

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

    final fullPhoneNumber = '$_selectedCountryCode$rawPhone';

    if (!RegexValidators.isPhoneNumber(fullPhoneNumber)) {
      SnackbarUtils.showError(context, l10n.valPhoneInvalid);
      return;
    }

    try {
      // حفظ رقم التليفون في الـ Firestore للـ Current User
      await ref.read(authProvider.notifier).saveUserPhoneNumber(phone: fullPhoneNumber);
      
      final authState = ref.read(authProvider);
      if (authState.errorMessage != null) {
        SnackbarUtils.showError(context, authState.errorMessage!);
        return;
      }

      // تمرير الرقم بعد الحفظ الناجح للانتقال للخطوة التالية
      widget.onVerified(fullPhoneNumber);
      
    } catch (e) {
      SnackbarUtils.showError(context, "Failed to save phone number. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneVerificationProvider);
    final authState = ref.watch(authProvider);
    final isLoading = state.status == PhoneVerificationStatus.loading || authState.isLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.phoneNumberSubtitle,
                    style: AppTextStyles.bodyLargeRegular.copyWith(
                      color: AppColors.grey500,
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
                      style: AppTextStyles.bodyMediumMedium,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Container(
                        height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.grey300 ?? Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            items: const [
                              DropdownMenuItem(
                                  value: '+20',
                                  child: Text('🇪🇬 +20',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DropdownMenuItem(
                                  value: '+966',
                                  child: Text('🇸🇦 +966',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DropdownMenuItem(
                                  value: '+971',
                                  child: Text('🇦🇪 +971',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DropdownMenuItem(
                                  value: '+1',
                                  child: Text('🇺🇸 +1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCountryCode = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: "1001234567",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: SvgPicture.asset(
                              AppAssets.call,
                              width: 19.w,
                              height: 19.h,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary500,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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