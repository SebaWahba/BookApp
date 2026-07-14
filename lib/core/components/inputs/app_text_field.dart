import 'package:bookapp/config/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.autovalidateMode,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
  });
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      keyboardType: keyboardType,
      cursorColor: AppColors.primary500,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
