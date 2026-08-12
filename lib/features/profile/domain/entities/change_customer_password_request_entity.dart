class ChangeCustomerPasswordRequestEntity {
  const ChangeCustomerPasswordRequestEntity({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}
