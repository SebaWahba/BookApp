enum VerificationContactType {
  email,
  phone,
}
extension VerificationContactTypeX on VerificationContactType {
  String get title {
    switch (this) {
      case VerificationContactType.email:
        return 'email';

      case VerificationContactType.phone:
        return 'phone number';
    }
  }
}