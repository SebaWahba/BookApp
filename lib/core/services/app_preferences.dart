import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small, device-local settings that outlive a session and aren't tied to an
/// account (so they can't live on the user document).
abstract class AppPreferences {
  Future<bool> hasSeenOnboarding();
  Future<void> setOnboardingSeen();
}

class AppPreferencesImpl implements AppPreferences {
  static const String _onboardingSeenKey = 'onboarding_seen';

  @override
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  @override
  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }
}

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferencesImpl();
});
