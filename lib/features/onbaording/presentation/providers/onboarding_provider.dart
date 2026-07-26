import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int index) {
    state = index;
  }
}

final onboardingPageIndexProvider =
    NotifierProvider<OnboardingPageIndexNotifier, int>(
      OnboardingPageIndexNotifier.new,
    );
