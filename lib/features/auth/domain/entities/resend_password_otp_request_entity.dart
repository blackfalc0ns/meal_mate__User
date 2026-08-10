class ResendPasswordOtpRequestEntity {
  const ResendPasswordOtpRequestEntity({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;
}
