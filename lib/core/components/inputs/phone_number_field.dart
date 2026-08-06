import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../constants/app_spacing.dart';
import '../../utils/phone_number.dart';
import 'app_text_field.dart';

export '../../utils/phone_number.dart' show CountryDialCode;

/// Country-code picker paired with a national-number field.
///
/// Both the sign-up and forgot-password flows write and read phone numbers, and
/// a number only matches if the two screens compose it identically — so they
/// share this widget rather than each rolling their own picker.
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.dialCode,
    required this.onDialCodeChanged,
    this.hintText,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.countries = CountryDialCode.supported,
  });

  final TextEditingController controller;
  final String dialCode;
  final ValueChanged<String> onDialCodeChanged;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final bool enabled;
  final List<CountryDialCode> countries;

  /// Matches the app's filled text fields so the picker sits flush beside one.
  static const double _fieldHeight = 56.0;

  /// Joins a dialling code and a national number into the single string that
  /// gets stored on, and looked up from, the user document.
  static String compose(String dialCode, String localNumber) =>
      PhoneNumber.compose(dialCode, localNumber);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor =
        theme.inputDecorationTheme.fillColor ??
        (isDark ? AppColors.grey800 : AppColors.grey50);

    return Row(
      // Start-aligned so a validation message under the number field pushes
      // text downwards instead of stretching the picker to match.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _fieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dialCode,
              isDense: true,
              borderRadius: BorderRadius.circular(8),
              dropdownColor: fillColor,
              iconEnabledColor: AppColors.grey500,
              style: AppTextStyles.bodyMediumMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              items: [
                for (final country in countries)
                  DropdownMenuItem(
                    value: country.dialCode,
                    child: Text('${country.flag} ${country.dialCode}'),
                  ),
              ],
              onChanged: enabled
                  ? (value) {
                      if (value != null) onDialCodeChanged(value);
                    }
                  : null,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppTextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            hintText: hintText,
            validator: validator,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
