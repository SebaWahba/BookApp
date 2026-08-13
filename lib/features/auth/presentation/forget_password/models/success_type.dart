enum SuccessType { verification, resetPassword }

extension SuccessTypeX on SuccessType {
  String get title => switch (this) {
    SuccessType.verification => 'Verification Successful',
    SuccessType.resetPassword => 'Password Changed',
  };

  String get description => switch (this) {
    SuccessType.verification =>
      'your account is complete, please enjoy the best menu from us.',

    SuccessType.resetPassword =>
      'Password changed successfully, you can login again with a new password',
  };

  String get buttonText => switch (this) {
    SuccessType.verification => 'Get Started',
    SuccessType.resetPassword => 'Login',
  };
}
