import 'package:bookapp/core/network/firebase_auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/services/app_preferences.dart';

/// Where the app should land on launch.
enum StartDestination { onboarding, login, home }

extension StartDestinationX on StartDestination {
  String get route => switch (this) {
    StartDestination.onboarding => AppRoutes.onboarding,
    StartDestination.login => AppRoutes.login,
    StartDestination.home => AppRoutes.home,
  };
}

/// Resolves the launch destination from the restored session and whether
/// onboarding has been seen before.
///
/// Never throws — a failure here would strand the user on the splash screen, so
/// it falls back to the pre-existing behaviour of showing onboarding.
final startDestinationProvider = FutureProvider<StartDestination>((ref) async {
  try {
    // `currentUser` is null until Firebase finishes restoring persisted
    // credentials, so reading it synchronously right after startup would report
    // a signed-in user as signed out. The first authStateChanges event fires
    // once restoration is done.
    final preferences = ref.read(appPreferencesProvider);

    final user = await ref.read(firebaseAuthProvider).authStateChanges().first;
    if (user != null) {
      if (!user.emailVerified) {
        // Sign out the unverified session
        await ref.read(firebaseAuthProvider).signOut();
        // Clear local auth session preferences but keep onboarding state
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.remove('user_email');
        await prefs.remove('user_uid');
        await prefs.remove('is_logged_in');

        final seenOnboarding = await preferences.hasSeenOnboarding();
        return seenOnboarding ? StartDestination.login : StartDestination.onboarding;
      }

      // Someone already signed in has effectively finished onboarding, even if
      // they never saw it — a session predating this flag, or a sign-up that
      // skipped ahead. Recording it here is what stops a later logout from
      // dropping them back into onboarding instead of login.
      await preferences.setOnboardingSeen();
      return StartDestination.home;
    }

    final seenOnboarding = await preferences.hasSeenOnboarding();
    return seenOnboarding
        ? StartDestination.login
        : StartDestination.onboarding;
  } catch (e) {
    debugPrint('Startup destination resolution failed: $e');
    return StartDestination.onboarding;
  }
});
