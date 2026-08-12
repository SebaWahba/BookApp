/// A dialling code the app can compose numbers with.
class CountryDialCode {
  const CountryDialCode({
    required this.dialCode,
    required this.flag,
    required this.name,
  });

  final String dialCode;
  final String flag;
  final String name;

  static const List<CountryDialCode> supported = [
    CountryDialCode(dialCode: '+20', flag: '🇪🇬', name: 'Egypt'),
    CountryDialCode(dialCode: '+966', flag: '🇸🇦', name: 'Saudi Arabia'),
    CountryDialCode(
      dialCode: '+971',
      flag: '🇦🇪',
      name: 'United Arab Emirates',
    ),
    CountryDialCode(dialCode: '+1', flag: '🇺🇸', name: 'United States'),
  ];
}

/// The single definition of how a phone number is turned into the string that
/// gets stored on, and looked up from, a user document.
///
/// Sign-up and forgot-password must agree exactly or an account becomes
/// unreachable by phone, so both go through [compose] rather than concatenating
/// their own.
class PhoneNumber {
  PhoneNumber._();

  /// Builds the canonical E.164 form: `+<dial code><national number>`.
  ///
  /// The national trunk prefix is dropped — Egyptians dial `01023798556`
  /// locally, but the international form is `+201023798556`, not
  /// `+2001023798556`. Leaving it in was why a number saved at sign-up couldn't
  /// be found at reset.
  static String compose(String dialCode, String localNumber) {
    final code = _digitsOf(dialCode);
    final national = _stripTrunkPrefix(_digitsOf(localNumber));
    if (code.isEmpty && national.isEmpty) return '';
    return '+$code$national';
  }

  /// Every stored spelling of [e164] worth matching against.
  ///
  /// Earlier builds concatenated the dial code onto whatever was typed, so the
  /// same person may be stored as `+201023798556`, `+2001023798556`,
  /// `01023798556` or `1023798556`. Rather than migrate the data, the lookup
  /// accepts all of them.
  static List<String> lookupCandidates(String e164) {
    final trimmed = e164.trim();
    final digits = _digitsOf(trimmed);
    if (digits.isEmpty) return const [];

    final candidates = <String>{trimmed, digits, '+$digits'};

    // Longest dial code first, so '+971' isn't shadowed by a shorter match.
    final dialCodes =
        CountryDialCode.supported.map((c) => _digitsOf(c.dialCode)).toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    for (final code in dialCodes) {
      if (!digits.startsWith(code)) continue;

      final national = _stripTrunkPrefix(digits.substring(code.length));
      candidates.addAll({
        '+$code$national', // canonical
        '$code$national', // canonical without the '+'
        '+${code}0$national', // trunk prefix left in by an older build
        '${code}0$national',
        '0$national', // saved before any dial code was prepended
        national,
      });
      break;
    }

    return candidates.where((c) => c.isNotEmpty).toList();
  }

  static String _digitsOf(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  static String _stripTrunkPrefix(String digits) =>
      digits.replaceFirst(RegExp(r'^0+'), '');
}
