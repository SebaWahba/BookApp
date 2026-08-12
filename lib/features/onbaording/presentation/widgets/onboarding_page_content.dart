import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnbaordingModel model;
  const OnboardingPageContent({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: ResponsiveBuilder(
        mobile: (context) => _MobileContent(model: model, l10n: AppLocalizations.of(context)!),
        tablet: (context) => _TabletContent(model: model, l10n: AppLocalizations.of(context)!),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  final OnbaordingModel model;
  final AppLocalizations l10n;
  const _MobileContent({required this.model, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(flex: 3, child: SvgPicture.asset(model.imagePath)),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    model.title(l10n),
                    style: context.type.h3.copyWith(color: context.colors.title),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    model.description(l10n),
                    style: context.type.bodyLargeRegular.copyWith(color: context.colors.body),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabletContent extends StatelessWidget {
  final OnbaordingModel model;
  final AppLocalizations l10n;
  const _TabletContent({required this.model, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final isShort = constraints.maxHeight < 320;
        final imageFlex = isNarrow ? 3 : 5;
        final textFlex = isNarrow ? 5 : 4;

        final baseTitleStyle = context.type.h3;
        final titleStyle = (isShort
            ? baseTitleStyle.copyWith(fontSize: (baseTitleStyle.fontSize ?? 20) * 0.85)
            : baseTitleStyle)
            .copyWith(color: context.colors.title);

        final baseDescStyle = context.type.bodyLargeRegular;
        final descStyle = baseDescStyle.copyWith(
          color: context.colors.body,
          fontSize: isShort
              ? (baseDescStyle.fontSize ?? 16) * 0.85
              : baseDescStyle.fontSize,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: imageFlex,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SvgPicture.asset(model.imagePath),
              ),
            ),
            SizedBox(width: isShort ? AppSpacing.md : AppSpacing.xl),
            Expanded(
              flex: textFlex,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.title(l10n),
                      style: titleStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isShort ? AppSpacing.md : AppSpacing.xl),
                    Text(
                      model.description(l10n),
                      style: descStyle,
                      maxLines: isShort ? 3 : 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}