import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// TODO: text colors are placeholder (grey900) , need to verify each style.
// exact color against figma ("Gray 2" #333333 does not exist in AppColors yet and not in figma colors)

class AppTextStyles {
  // headings > Open Sans, Bold
  static TextStyle get h1 => GoogleFonts.openSans(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );
  static TextStyle get h2 => GoogleFonts.openSans(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );
  static TextStyle get h3 => GoogleFonts.openSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );
  static TextStyle get h4 => GoogleFonts.openSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );
  static TextStyle get h5 => GoogleFonts.openSans(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );
  static TextStyle get h6 => GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
  );

  // body xlarge > 18px
  static TextStyle get bodyXLargeMedium => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.grey900,
  );

  // body large > 16px
  static TextStyle get bodyLargeSemiBold => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
  );
  static TextStyle get bodyLargeMedium => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.grey900,
  );
  static TextStyle get bodyLargeRegular => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey900,
  );

  // body medium > 14px
  static TextStyle get bodyMediumBold => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
  );
  static TextStyle get bodyMediumSemiBold => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
  );
  static TextStyle get bodyMediumMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey900,
  );
  static TextStyle get bodyMediumRegular => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey900,
  );

  // body small > 12px
  static TextStyle get bodySmallBold => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
  );
  static TextStyle get bodySmallSemiBold => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
  );
  static TextStyle get bodySmallMedium => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey900,
  );
  static TextStyle get bodySmallRegular => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey900,
  );
}
