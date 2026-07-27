class RegexValidators {
  RegexValidators._();

  /// Returns true if [s] has at least [min] characters.
  static bool hasMinLength(String? s, [int min = 8]) {
    if (s == null) return false;
    return s.length >= min;
  }

  /// Returns true if [s] contains at least one digit.
  static bool hasNumber(String? s) {
    if (s == null) return false;
    return RegExp(r"\d").hasMatch(s);
  }

  /// Returns true if [s] contains at least one letter (A-Z or a-z).
  static bool hasLetter(String? s) {
    if (s == null) return false;
    return RegExp(r"[A-Za-z]").hasMatch(s);
  }

  /// Simple email check.
  static bool isEmail(String? s) {
    if (s == null) return false;
    // Require full-string match (anchor end with $) so trailing SQL/text is rejected.
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

  /// Validator that returns an error message or null when valid.
  static String? phoneValidator(String? s) {
    if (s == null || s.trim().isEmpty) return 'Phone number is required';
    if (!isPhoneNumber(s)) return 'Enter a valid phone number';
    return null;
  }

  /// Validator that returns a localized-ish message or null when valid.
  static String? passwordValidator(String? s, {int minLength = 8}) {
    if (s == null || s.isEmpty) return 'Password is required';
    if (!hasMinLength(s, minLength)) return 'Minimum $minLength characters';
    if (!hasNumber(s)) return 'At least one number required';
    if (!hasLetter(s)) return 'At least one letter required';
    return null;
  }
}
