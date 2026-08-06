import 'package:bookapp/l10n/app_localizations.dart';

import 'verification_contact_type.dart';

/// Why a step of the reset flow failed, kept separate from the wording so the
/// message can be localized where it is shown.
enum ForgetPasswordError {
  accountNotFound,
  lookupFailed,
  invalidCode,
  expiredCode,
  sessionRequired,
  updateFailed,
}

extension ForgetPasswordErrorX on ForgetPasswordError {
  /// [contactType] tailors the not-found wording — telling someone to check the
  /// country code is only useful if they entered a phone number.
  String message(
    AppLocalizations l10n, {
    VerificationContactType? contactType,
  }) => switch (this) {
    ForgetPasswordError.accountNotFound =>
      contactType == VerificationContactType.phone
          ? l10n.resetAccountNotFoundPhone
          : l10n.resetAccountNotFoundEmail,
    ForgetPasswordError.lookupFailed => l10n.resetLookupFailed,
    ForgetPasswordError.invalidCode => l10n.resetCodeInvalid,
    ForgetPasswordError.expiredCode => l10n.resetCodeExpired,
    ForgetPasswordError.sessionRequired => l10n.resetSessionRequired,
    ForgetPasswordError.updateFailed => l10n.resetPasswordFailed,
  };
}
