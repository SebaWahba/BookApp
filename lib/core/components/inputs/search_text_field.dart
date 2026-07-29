import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool autofocus;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: true,
      style: AppTextStyles.bodyLargeRegular.copyWith(color: AppColors.grey900),
      decoration: InputDecoration(
        hintText: 'Search books, authors…',
        hintStyle: AppTextStyles.bodyLargeRegular.copyWith(
          color: AppColors.grey400,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                controller.clear();
              },
            );
          },
        ),
      ),
    );
  }
}
