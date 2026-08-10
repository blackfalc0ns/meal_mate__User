class ForgotPasswordRequestEntity {
  const ForgotPasswordRequestEntity({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;
}
