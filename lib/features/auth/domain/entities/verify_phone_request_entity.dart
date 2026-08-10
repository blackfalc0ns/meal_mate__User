class VerifyPhoneRequestEntity {
  const VerifyPhoneRequestEntity({
    required this.phone,
    required this.code,
    required this.countryCode,
  });

  final String phone;
  final String code;
  final String countryCode;
}
