class AppStrings {
  AppStrings._();

  // ==================== Onboarding Screen ====================
  static const String onboardingSkip = 'Skip';
  static const String onboardingContinue = 'Continue';
  static const String onboardingGetStarted = 'Get Started';

  // ==================== Sign In Screen ====================
  static const String signInTitle = 'Welcome Back';
  static const String signInSubtitle = 'Sign in to your Bazar account';
  static const String emailLabel = 'Email Address';
  static const String passwordLabel = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String signInBtn = 'Sign In';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUpLink = 'Sign Up';

  // ==================== Sign Up Screen ====================
  static const String signUpTitle = 'Create Account';
  static const String signUpSubtitle = 'Join Bazar marketplace today';
  static const String fullNameLabel = 'Full Name';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInLink = 'Sign In';

  // ==================== Verification Screen ====================
  static const String verifyTitle = 'Verification Code';
  static const String verifySubtitle = 'Please enter the code sent to';
  static const String verifyBtn = 'Verify';
  static const String resendText = "Didn't receive code? ";
  static const String resendBtn = 'Resend';

  // ==================== Validation Messages ====================
  static const String valEmailEmpty = 'Please enter your email';
  static const String valEmailInvalid = 'Please enter a valid email address';
  static const String valPasswordEmpty = 'Please enter your password';
  static const String valPasswordLength = 'Password must be at least 8 characters long';
  static const String valPasswordUppercase = 'Password must contain at least one uppercase letter';
  static const String valPasswordNumber = 'Password must contain at least one number';
  static const String valPasswordSpecial = 'Password must contain at least one special character (!@#\$&*~)';
  static const String valNameEmpty = 'Please enter your name';
  static const String valNameInvalid = 'Please enter your full name (at least first and last name)';
}