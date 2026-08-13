class RegexValidators {
  RegexValidators._();

  static bool hasMinLength(String? s, [int min = 8]) {
    if (s == null) return false;
    return s.length >= min;
  }

  static bool hasNumber(String? s) {
    if (s == null) return false;
    return RegExp(r"\d").hasMatch(s);
  }

  static bool hasLetter(String? s) {
    if (s == null) return false;
    return RegExp(r"[A-Za-z]").hasMatch(s);
  }

  static bool isEmail(String? s) {
    if (s == null) return false;
    final emailRegex = RegExp(r"^[\w\-.]+@([\w\-]+\.)+[A-Za-z]{2,}");
    return emailRegex.hasMatch(s) &&
        RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(s);
  }

  /// International phone check (E.164-style): optional '+', 8-15 digits.
  static bool isPhoneNumber(String? s) {
    if (s == null) return false;
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(s.trim());
  }

  /// Egyptian mobile number check (e.g. 010, 011, 012, 015 followed by 8 digits)
  static bool isEgyptianMobileNumber(String? s) {
    if (s == null) return false;
    final regex = RegExp(r'^01[0125][0-9]{8}$');
    return regex.hasMatch(s.trim());
  }

  static String? passwordValidator(String? s, {int minLength = 8}) {
    if (s == null || s.isEmpty) return 'Password is required';
    if (!hasMinLength(s, minLength)) return 'Minimum $minLength characters';
    if (!hasNumber(s)) return 'At least one number required';
    if (!hasLetter(s)) return 'At least one letter required';
    return null;
  }
}
