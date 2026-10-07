import 'package:meal_meat_user/core/network/failures.dart';

enum RegisterOutcome {
  idle,
  registrationSuccess,
  phoneVerifiedSuccess,
  failure,
}

class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.isResending = false,
    this.outcome = RegisterOutcome.idle,
    this.failure,
    this.snapshotPhone,
    this.snapshotCountryCode,
    this.snapshotFullName,
    this.userId,
    this.resendOtpSent = false,
    this.retryAvailableAtUtc,
  });

  final bool isLoading;
  final bool isResending;
  final RegisterOutcome outcome;
  final Failure? failure;
  final String? snapshotPhone;
  final String? snapshotCountryCode;
  final String? snapshotFullName;
  final String? userId;
  final bool resendOtpSent;
  final DateTime? retryAvailableAtUtc;

  bool get hasActiveVerification =>
      snapshotPhone != null &&
      snapshotPhone!.isNotEmpty &&
      snapshotCountryCode != null &&
      snapshotCountryCode!.isNotEmpty;

  RegisterState copyWith({
    bool? isLoading,
    bool? isResending,
    RegisterOutcome? outcome,
    Failure? Function()? failure,
    String? Function()? snapshotPhone,
    String? Function()? snapshotCountryCode,
    String? Function()? snapshotFullName,
    String? Function()? userId,
    bool? resendOtpSent,
    DateTime? Function()? retryAvailableAtUtc,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      outcome: outcome ?? this.outcome,
      failure: failure != null ? failure() : this.failure,
      snapshotPhone:
          snapshotPhone != null ? snapshotPhone() : this.snapshotPhone,
      snapshotCountryCode: snapshotCountryCode != null
          ? snapshotCountryCode()
          : this.snapshotCountryCode,
      snapshotFullName: snapshotFullName != null
          ? snapshotFullName()
          : this.snapshotFullName,
      userId: userId != null ? userId() : this.userId,
      resendOtpSent: resendOtpSent ?? this.resendOtpSent,
      retryAvailableAtUtc: retryAvailableAtUtc != null
          ? retryAvailableAtUtc()
          : this.retryAvailableAtUtc,
    );
  }
}
