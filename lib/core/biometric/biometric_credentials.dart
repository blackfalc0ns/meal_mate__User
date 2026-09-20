class BiometricCredentials {
  const BiometricCredentials({
    required this.phone,
    required this.password,
    required this.countryCode,
  });

  final String phone;
  final String password;
  final String countryCode;

  @override
  String toString() =>
      'BiometricCredentials(phone: $phone, countryCode: $countryCode)';
}
