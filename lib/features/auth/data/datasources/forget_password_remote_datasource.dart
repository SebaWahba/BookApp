import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:bookapp/core/utils/phone_number.dart';

/// Outcome of checking a user-entered code against the issued one.
enum OtpCheckResult { valid, invalid, expired }

/// Thrown when a password change is attempted without an authenticated session.
///
/// See [ForgetPasswordRemoteDataSourceImpl.updatePassword] for why this happens
/// and what has to change to remove it.
class NoResetSessionException implements Exception {
  const NoResetSessionException();
}

abstract class ForgetPasswordRemoteDataSource {
  /// Returns the account's email for [contact], or null when no account
  /// matches. When [isPhone], [contact] is a phone number and the email is
  /// read off the matching user document.
  Future<String?> findAccountEmail(String contact, {required bool isPhone});

  /// Generates a fresh code and makes it the only one [checkOtp] will accept.
  String issueOtp();

  OtpCheckResult checkOtp(String code);

  Future<void> updatePassword({
    required String email,
    required String newPassword,
  });
}

class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
  ForgetPasswordRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  static const Duration _otpTtl = Duration(minutes: 5);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Random _random = Random.secure();

  String? _issuedOtp;
  DateTime? _issuedAt;

  /// Debug-only tracing of the account lookup.
  ///
  /// Emails and phone numbers are personal data, so this is gated on
  /// [kDebugMode] and must never reach a release build's logs.
  void _log(String message) {
    if (kDebugMode) debugPrint('[ForgetPassword] $message');
  }

  /// Prints what is actually stored so a format mismatch is visible: the usual
  /// cause of a failed lookup is a stored '+201001234567' versus a searched
  /// '01001234567'.
  Future<void> _logStoredPhones() async {
    if (!kDebugMode) return;
    try {
      final snapshot = await _firestore.collection('users').get();
      final stored = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return '${data['email'] ?? '?'} -> '
                '${data['phone'] ?? data['phoneNumber'] ?? '(none)'}';
          })
          .join('\n  ');
      _log('stored numbers (${snapshot.docs.length}):\n  $stored');
    } catch (e) {
      _log('could not read stored numbers: $e');
    }
  }

  @override
  Future<String?> findAccountEmail(
    String contact, {
    required bool isPhone,
  }) async {
    final cleaned = contact.trim();
    _log('lookup by ${isPhone ? 'phone' : 'email'}: "$cleaned"');

    if (cleaned.isEmpty) {
      _log('empty input — no lookup performed');
      return null;
    }

    // NOTE: this reads `users` while nobody is signed in, so it only works if
    // Firestore rules allow public reads there — which also makes it an
    // account-enumeration oracle. The repository deliberately returns the same
    // generic error whether or not a match is found. Moving this lookup behind
    // a Cloud Function is the real fix.
    if (isPhone) {
      // Match every spelling earlier builds wrote, not just today's canonical
      // one, so accounts saved before composition was unified stay reachable.
      final candidates = PhoneNumber.lookupCandidates(cleaned);
      _log('trying ${candidates.length} variants: ${candidates.join(', ')}');

      // Sign-up writes `phone`; older documents used `phoneNumber`.
      for (final field in const ['phone', 'phoneNumber']) {
        final snapshot = await _firestore
            .collection('users')
            .where(field, whereIn: candidates)
            .get();

        for (final doc in snapshot.docs) {
          final email = doc.data()['email'] as String?;
          if (email != null && email.isNotEmpty) {
            _log(
              'matched "${doc.data()[field]}" on "$field" -> account $email',
            );
            return email;
          }
        }

        if (snapshot.docs.isNotEmpty) {
          _log('matched on "$field" but no document carries an email');
        }
      }

      _log('no account has phone "$cleaned"');
      await _logStoredPhones();
      return null;
    }

    // Sign-up stores the address exactly as Firebase reports it, which is not
    // necessarily lower-case, so try the typed casing before the folded one.
    for (final candidate in <String>{cleaned, cleaned.toLowerCase()}) {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: candidate)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _log('matched email candidate "$candidate"');
        return snapshot.docs.first.data()['email'] as String? ?? candidate;
      }
    }

    _log('no account has email "$cleaned"');
    return null;
  }

  @override
  String issueOtp() {
    final code = (1000 + _random.nextInt(9000)).toString();
    _issuedOtp = code;
    _issuedAt = DateTime.now();
    return code;
  }

  @override
  OtpCheckResult checkOtp(String code) {
    final issued = _issuedOtp;
    final issuedAt = _issuedAt;
    if (issued == null || issuedAt == null) return OtpCheckResult.expired;

    if (DateTime.now().difference(issuedAt) > _otpTtl) {
      _clearOtp();
      return OtpCheckResult.expired;
    }

    if (code.trim() != issued) return OtpCheckResult.invalid;

    // Single use — a verified code must not unlock a second password change.
    _clearOtp();
    return OtpCheckResult.valid;
  }

  void _clearOtp() {
    _issuedOtp = null;
    _issuedAt = null;
  }

  /// Lets the reset complete without actually setting a password when the
  /// client can't legitimately do so.
  ///
  /// ⚠️ DEMO ONLY — MUST BE `false` BEFORE RELEASE. ⚠️
  ///
  /// The Firebase client SDK can only set a password on an authenticated
  /// session: `currentUser.updatePassword` is the sole entry point, and there
  /// is no `updatePasswordFor(email, …)`. A forgot-password flow has no
  /// session, so with no backend the reset genuinely cannot be performed.
  ///
  /// With this `true` the flow reports success and the password is NOT changed
  /// — the user can still only sign in with their old one. That is acceptable
  /// for a walkthrough and dangerous in production.
  ///
  /// Setting it to `false` restores honest behaviour: the user is told to sign
  /// in first. The real fix is a Cloud Function validating the OTP server-side
  /// and calling the Admin SDK's `updateUser(uid, password:)`; it drops into
  /// this method without touching the repository or anything above it.
  static const bool simulateResetWithoutSession = true;

  @override
  Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final sessionEmail = user?.email;

    // Only ever touch a session that belongs to the account being reset —
    // being signed in as somebody else must never change their password.
    final sessionMatchesAccount =
        user != null &&
        (sessionEmail == null ||
            sessionEmail.toLowerCase() == email.toLowerCase());

    if (sessionMatchesAccount) {
      try {
        await user.updatePassword(newPassword);
        return;
      } on FirebaseAuthException catch (e) {
        // A long-lived session can't change a password without reauthenticating.
        final recoverable =
            e.code == 'requires-recent-login' || e.code == 'user-token-expired';
        if (!simulateResetWithoutSession || !recoverable) rethrow;
      }
    }

    if (!simulateResetWithoutSession) throw const NoResetSessionException();

    // Simulated: stands in for the server call, so the flow can be walked
    // end to end. Nothing is persisted.
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
