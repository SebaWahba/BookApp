import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.type});
  final SuccessType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.successSvg),
              const Gap(40),
              Text(type.title, style: AppTextStyles.h3),
              const Gap(AppSpacing.sm),
              Text(
                type.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const Gap(AppSpacing.xxxl),
              PrimaryButton(
                text: type.buttonText,
                onPressed: () {
                  if (type == SuccessType.verification) {
                    context.go(AppRoutes.home);
                  } else {
                    context.go(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
