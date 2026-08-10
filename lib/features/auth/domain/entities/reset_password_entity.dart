class ResetPasswordEntity {
  const ResetPasswordEntity({
    required this.success,
    required this.passwordReset,
    required this.nextStep,
  });

  final bool success;
  final bool passwordReset;
  final String nextStep;
}
