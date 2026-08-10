class ResendPhoneOtpRequestEntity {
  const ResendPhoneOtpRequestEntity({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;
}
