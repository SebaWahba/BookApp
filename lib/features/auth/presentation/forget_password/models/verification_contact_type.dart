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
    VerificationContactType.phone => '(+965) 123 435 7565',
  };

  IconData? get prefixIcon => switch (this) {
    VerificationContactType.email => null,
    VerificationContactType.phone => Icons.phone,
  };
}
