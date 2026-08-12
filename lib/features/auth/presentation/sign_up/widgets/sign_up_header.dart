import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignUpHeader({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.type.h3.copyWith(color: context.colors.title),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}