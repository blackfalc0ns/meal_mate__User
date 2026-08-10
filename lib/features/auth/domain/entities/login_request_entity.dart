class LoginRequestEntity {
  const LoginRequestEntity({
    required this.phone,
    required this.password,
    required this.countryCode,
  });

  final String phone;
  final String password;
  final String countryCode;
}
