/// A pending password-reset attempt.
///
/// [email] is the account the reset applies to. The user may have identified
/// themselves by phone number instead, so this is the *resolved* account email
/// rather than whatever they typed.
///
/// [code] is the verification code that was issued. Delivery is simulated, so
/// the code travels back to the UI to be displayed; once a real mail/SMS
/// provider is wired up it should stop crossing the layer boundary.
class PasswordResetChallenge {
  const PasswordResetChallenge({required this.email, required this.code});

  final String email;
  final String code;
}
