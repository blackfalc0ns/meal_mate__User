import 'package:meal_meat_user/core/errors/failures.dart';

enum PasswordRecoveryOutcome {
  idle,
  otpSentSuccess,
  otpCodeReady,
  resetSuccess,
  failure,
}

class PasswordRecoveryState {
  const PasswordRecoveryState({
    this.isLoading = false,
    this.isResending = false,
    this.outcome = PasswordRecoveryOutcome.idle,
    this.failure,
    this.snapshotPhone,
    this.snapshotCountryCode,
    this.otpCode,
    this.resendOtpSent = false,
    this.retryAvailableAtUtc,
  });

  final bool isLoading;
  final bool isResending;
  final PasswordRecoveryOutcome outcome;
  final Failure? failure;
  final String? snapshotPhone;
  final String? snapshotCountryCode;
  final String? otpCode;
  final bool resendOtpSent;
  final DateTime? retryAvailableAtUtc;

  bool get hasActiveRecovery =>
      snapshotPhone != null &&
      snapshotPhone!.isNotEmpty &&
      snapshotCountryCode != null &&
      snapshotCountryCode!.isNotEmpty;

  PasswordRecoveryState copyWith({
    bool? isLoading,
    bool? isResending,
    PasswordRecoveryOutcome? outcome,
    Failure? Function()? failure,
    String? Function()? snapshotPhone,
    String? Function()? snapshotCountryCode,
    String? Function()? otpCode,
    bool? resendOtpSent,
    DateTime? Function()? retryAvailableAtUtc,
  }) {
    return PasswordRecoveryState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      outcome: outcome ?? this.outcome,
      failure: failure != null ? failure() : this.failure,
      snapshotPhone: snapshotPhone != null
          ? snapshotPhone()
          : this.snapshotPhone,
      snapshotCountryCode: snapshotCountryCode != null
          ? snapshotCountryCode()
          : this.snapshotCountryCode,
      otpCode: otpCode != null ? otpCode() : this.otpCode,
      resendOtpSent: resendOtpSent ?? this.resendOtpSent,
      retryAvailableAtUtc: retryAvailableAtUtc != null
          ? retryAvailableAtUtc()
          : this.retryAvailableAtUtc,
    );
  }
}
