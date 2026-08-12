import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.h6,
    required this.bodyXLargeMedium,
    required this.bodyLargeSemiBold,
    required this.bodyLargeMedium,
    required this.bodyLargeRegular,
    required this.bodyMediumBold,
    required this.bodyMediumSemiBold,
    required this.bodyMediumMedium,
    required this.bodyMediumRegular,
    required this.bodySmallBold,
    required this.bodySmallSemiBold,
    required this.bodySmallMedium,
    required this.bodySmallRegular,
  });

  factory AppTypography.regular() => AppTypography(
    h1: GoogleFonts.openSans(fontSize: 40, fontWeight: FontWeight.bold),
    h2: GoogleFonts.openSans(fontSize: 32, fontWeight: FontWeight.bold),
    h3: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
    h4: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
    h5: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
    h6: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
    bodyXLargeMedium: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLargeSemiBold: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLargeMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLargeRegular: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMediumBold: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w700),
    bodyMediumSemiBold: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w600),
    bodyMediumMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
    bodyMediumRegular: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmallBold: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700),
    bodySmallSemiBold: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600),
    bodySmallMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
    bodySmallRegular: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400),
  );

  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle h6;

  final TextStyle bodyXLargeMedium;
  final TextStyle bodyLargeSemiBold;
  final TextStyle bodyLargeMedium;
  final TextStyle bodyLargeRegular;
  final TextStyle bodyMediumBold;
  final TextStyle bodyMediumSemiBold;
  final TextStyle bodyMediumMedium;
  final TextStyle bodyMediumRegular;
  final TextStyle bodySmallBold;
  final TextStyle bodySmallSemiBold;
  final TextStyle bodySmallMedium;
  final TextStyle bodySmallRegular;

  @override
  AppTypography copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? bodyXLargeMedium,
    TextStyle? bodyLargeSemiBold,
    TextStyle? bodyLargeMedium,
    TextStyle? bodyLargeRegular,
    TextStyle? bodyMediumBold,
    TextStyle? bodyMediumSemiBold,
    TextStyle? bodyMediumMedium,
    TextStyle? bodyMediumRegular,
    TextStyle? bodySmallBold,
    TextStyle? bodySmallSemiBold,
    TextStyle? bodySmallMedium,
    TextStyle? bodySmallRegular,
  }) {
    return AppTypography(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      h6: h6 ?? this.h6,
      bodyXLargeMedium: bodyXLargeMedium ?? this.bodyXLargeMedium,
      bodyLargeSemiBold: bodyLargeSemiBold ?? this.bodyLargeSemiBold,
      bodyLargeMedium: bodyLargeMedium ?? this.bodyLargeMedium,
      bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
      bodyMediumBold: bodyMediumBold ?? this.bodyMediumBold,
      bodyMediumSemiBold: bodyMediumSemiBold ?? this.bodyMediumSemiBold,
      bodyMediumMedium: bodyMediumMedium ?? this.bodyMediumMedium,
      bodyMediumRegular: bodyMediumRegular ?? this.bodyMediumRegular,
      bodySmallBold: bodySmallBold ?? this.bodySmallBold,
      bodySmallSemiBold: bodySmallSemiBold ?? this.bodySmallSemiBold,
      bodySmallMedium: bodySmallMedium ?? this.bodySmallMedium,
      bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      h6: TextStyle.lerp(h6, other.h6, t)!,
      bodyXLargeMedium: TextStyle.lerp(bodyXLargeMedium, other.bodyXLargeMedium, t)!,
      bodyLargeSemiBold: TextStyle.lerp(bodyLargeSemiBold, other.bodyLargeSemiBold, t)!,
      bodyLargeMedium: TextStyle.lerp(bodyLargeMedium, other.bodyLargeMedium, t)!,
      bodyLargeRegular: TextStyle.lerp(bodyLargeRegular, other.bodyLargeRegular, t)!,
      bodyMediumBold: TextStyle.lerp(bodyMediumBold, other.bodyMediumBold, t)!,
      bodyMediumSemiBold: TextStyle.lerp(bodyMediumSemiBold, other.bodyMediumSemiBold, t)!,
      bodyMediumMedium: TextStyle.lerp(bodyMediumMedium, other.bodyMediumMedium, t)!,
      bodyMediumRegular: TextStyle.lerp(bodyMediumRegular, other.bodyMediumRegular, t)!,
      bodySmallBold: TextStyle.lerp(bodySmallBold, other.bodySmallBold, t)!,
      bodySmallSemiBold: TextStyle.lerp(bodySmallSemiBold, other.bodySmallSemiBold, t)!,
      bodySmallMedium: TextStyle.lerp(bodySmallMedium, other.bodySmallMedium, t)!,
      bodySmallRegular: TextStyle.lerp(bodySmallRegular, other.bodySmallRegular, t)!,
    );
  }
}