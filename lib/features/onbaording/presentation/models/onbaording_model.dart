import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class OnbaordingModel {
  final String titleKey;
  final String descriptionKey;
  final String imagePath;

  OnbaordingModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.imagePath,
  });

  String title(AppLocalizations l10n) {
    switch (titleKey) {
      case 'onboardingTitle1':
        return l10n.onboardingTitle1;
      case 'onboardingTitle2':
        return l10n.onboardingTitle2;
      case 'onboardingTitle3':
        return l10n.onboardingTitle3;
      default:
        return '';
    }
  }

  String description(AppLocalizations l10n) {
    switch (descriptionKey) {
      case 'onboardingDescription1':
        return l10n.onboardingDescription1;
      case 'onboardingDescription2':
        return l10n.onboardingDescription2;
      case 'onboardingDescription3':
        return l10n.onboardingDescription3;
      default:
        return '';
    }
  }
}

List<OnbaordingModel> onbaordingDataList = [
  OnbaordingModel(
    titleKey: 'onboardingTitle1',
    descriptionKey: 'onboardingDescription1',
    imagePath: AppAssets.onbaordingSvg1,
  ),
  OnbaordingModel(
    titleKey: 'onboardingTitle2',
    descriptionKey: 'onboardingDescription2',
    imagePath: AppAssets.onbaordingSvg2,
  ),
  OnbaordingModel(
    titleKey: 'onboardingTitle3',
    descriptionKey: 'onboardingDescription3',
    imagePath: AppAssets.onbaordingSvg3,
  ),
];
