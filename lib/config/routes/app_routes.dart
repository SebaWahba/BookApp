class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String vendors = '/vendors';
  static const String authors = '/authors';

  /// Sign-up's verification step. The forgot-password flow has its own
  /// ([forgetPasswordVerification]) because the two need different screens and
  /// different destinations once the code is accepted.
  static const String verificationCode = '/verification-code';
  static const String forgetPasswordVerification =
      '/forget-password/verification';
  static const String createNewPassword = '/create-new-password';
  static const String success = '/success';
  static const String forgetPassword = '/forget-password';
  static const String resetPassword = '/reset-password';
  static const String inputPhoneNumber = '/input-phone-number';
  static const String home = '/home';
  static const String allBooks = '/books';
  static const String bookDetails = '/book_details';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String myAccount = '/my_account';
  static const String myFavorite = '/my_favorite';
  static const String location = '/location';
}
