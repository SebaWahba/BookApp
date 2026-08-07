import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary500,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary500,
        brightness: Brightness.light,
        primary: AppColors.primary500,
        surface: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.grey900),
        titleTextStyle: AppTextStyles.h4,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLargeRegular,
        bodyMedium: AppTextStyles.bodyMediumRegular,
        bodySmall: AppTextStyles.bodySmallRegular,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey400),
        filled: true,
        fillColor: AppColors.grey50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary500),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary400,
      scaffoldBackgroundColor: AppColors.grey900,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary500,
        brightness: Brightness.dark,
        primary: AppColors.primary400,
        surface: AppColors.grey800,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.grey900,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: AppTextStyles.h4.copyWith(color: AppColors.white),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.white),
        headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.white),
        headlineSmall: AppTextStyles.h3.copyWith(color: AppColors.white),
        bodyLarge: AppTextStyles.bodyLargeRegular.copyWith(color: AppColors.white),
        bodyMedium: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.white),
        bodySmall: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500),
        filled: true,
        fillColor: AppColors.grey800,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary400),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? minHeight;

  const SocialButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
    this.borderRadius = 40.0,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: minHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(child: icon),
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
