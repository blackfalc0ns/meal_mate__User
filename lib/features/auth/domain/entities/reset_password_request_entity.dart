class ResetPasswordRequestEntity {
  const ResetPasswordRequestEntity({
    required this.phone,
    required this.otpCode,
    required this.newPassword,
    required this.countryCode,
  });

  final String phone;
  final String otpCode;
  final String newPassword;
  final String countryCode;
}
