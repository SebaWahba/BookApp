import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class SignInHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignInHeader({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.type.h3.copyWith(color: context.colors.title),
        ),
        const Gap(AppSpacing.lg),
        Text(
          subtitle,
          style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
        ),
        const Gap(AppSpacing.lg),
      ],
    );
  }
}
