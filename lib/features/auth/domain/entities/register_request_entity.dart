class RegisterRequestEntity {
  const RegisterRequestEntity({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.countryCode,
  });

  final String fullName;
  final String phone;
  final String password;
  final String countryCode;
}
