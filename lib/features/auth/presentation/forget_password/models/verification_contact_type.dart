import 'package:flutter/material.dart';

enum VerificationContactType { email, phone }

extension VerificationContactTypeX on VerificationContactType {
  String get title => switch (this) {
    //get bt5le el fun l var or Property
    VerificationContactType.email => 'Email',
    VerificationContactType.phone => 'Phone Number',
  };

  String get description => switch (this) {
    VerificationContactType.email =>
      'Please enter your email, we will send a verification code to your email.',

    VerificationContactType.phone =>
      'Please enter your phone number, we will send a verification code to your phone number.',
  };

  String get hint => switch (this) {
    VerificationContactType.email => 'example@email.com',
    // National number only — the dialling code comes from the picker beside it.
    VerificationContactType.phone => '100 123 4567',
  };

  IconData? get prefixIcon => switch (this) {
    VerificationContactType.email => null,
    VerificationContactType.phone => Icons.phone,
  };
}
