import 'package:bookapp/config/app_assets.dart';

class OnbaordingModel {
  final String title;
  final String description;
  final String imagePath;

  OnbaordingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnbaordingModel> onbaordingDataList = [
  OnbaordingModel(
    title: 'Now reading books will be easier',
    description:
        ' Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.',
    imagePath: AppAssets.onbaordingSvg1,
  ),
  OnbaordingModel(
    title: 'Your Bookish Soulmate Awaits',
    description:
        'Let us be your guide to the perfect read. Discover books tailored to your tastes for a truly rewarding experience.',
    imagePath: AppAssets.onbaordingSvg2,
  ),
  OnbaordingModel(
    title: 'Start Your Adventure',
    description:
        'Ready to embark on a quest for inspiration and knowledge? Your adventure begins now. Let\'s go!',
    imagePath: AppAssets.onbaordingSvg3,
  ),
];
