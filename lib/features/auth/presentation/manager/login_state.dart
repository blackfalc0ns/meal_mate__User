import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';

enum LoginOutcome {
  idle,
  success,
  failure,
  familyVerifyOtpPending,
  familySetPasswordPending,
}

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.isResending = false,
    this.resendOtpSent = false,
    this.outcome = LoginOutcome.idle,
    this.rememberMe = false,
    this.failure,
    this.isBiometricReady = false,
    this.biometricStatus,
    this.biometricErrorMessage,
    this.loginEntity,
    this.lastSubmittedRequestPhone,
    this.lastSubmittedRequestCountryCode,
    this.familyChallengeToken,
    this.familyChallengeExpiresAtUtc,
    this.familyNextStep,
    this.requiresFreshLogin = false,
  });

  final bool isLoading;
  final bool isResending;
  final bool resendOtpSent;
  final LoginOutcome outcome;
  final bool rememberMe;
  final Failure? failure;
  final bool isBiometricReady;
  final BiometricAuthStatus? biometricStatus;
  final String? biometricErrorMessage;
  final LoginEntity? loginEntity;
  final String? lastSubmittedRequestPhone;
  final String? lastSubmittedRequestCountryCode;
  final String? familyChallengeToken;
  final String? familyChallengeExpiresAtUtc;
  final String? familyNextStep;
  final bool requiresFreshLogin;

  bool get isSuccess => outcome == LoginOutcome.success;
  bool get isFamilyVerifyOtpPending =>
      outcome == LoginOutcome.familyVerifyOtpPending;
  bool get isFamilySetPasswordPending =>
      outcome == LoginOutcome.familySetPasswordPending;

  bool get isChallengeExpired {
    if (familyChallengeExpiresAtUtc == null) return false;
    final expires = DateTime.tryParse(familyChallengeExpiresAtUtc!);
    if (expires == null) return false;
    return DateTime.now().toUtc().isAfter(expires);
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isResending,
    bool? resendOtpSent,
    LoginOutcome? outcome,
    bool? rememberMe,
    Failure? Function()? failure,
    bool? isBiometricReady,
    BiometricAuthStatus? Function()? biometricStatus,
    String? Function()? biometricErrorMessage,
    LoginEntity? Function()? loginEntity,
    String? Function()? lastSubmittedRequestPhone,
    String? Function()? lastSubmittedRequestCountryCode,
    String? Function()? familyChallengeToken,
    String? Function()? familyChallengeExpiresAtUtc,
    String? Function()? familyNextStep,
    bool? requiresFreshLogin,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      resendOtpSent: resendOtpSent ?? this.resendOtpSent,
      outcome: outcome ?? this.outcome,
      rememberMe: rememberMe ?? this.rememberMe,
      failure: failure != null ? failure() : this.failure,
      isBiometricReady: isBiometricReady ?? this.isBiometricReady,
      biometricStatus: biometricStatus != null
          ? biometricStatus()
          : this.biometricStatus,
      biometricErrorMessage: biometricErrorMessage != null
          ? biometricErrorMessage()
          : this.biometricErrorMessage,
      loginEntity: loginEntity != null ? loginEntity() : this.loginEntity,
      lastSubmittedRequestPhone: lastSubmittedRequestPhone != null
          ? lastSubmittedRequestPhone()
          : this.lastSubmittedRequestPhone,
      lastSubmittedRequestCountryCode: lastSubmittedRequestCountryCode != null
          ? lastSubmittedRequestCountryCode()
          : this.lastSubmittedRequestCountryCode,
      familyChallengeToken: familyChallengeToken != null
          ? familyChallengeToken()
          : this.familyChallengeToken,
      familyChallengeExpiresAtUtc: familyChallengeExpiresAtUtc != null
          ? familyChallengeExpiresAtUtc()
          : this.familyChallengeExpiresAtUtc,
      familyNextStep: familyNextStep != null
          ? familyNextStep()
          : this.familyNextStep,
      requiresFreshLogin: requiresFreshLogin ?? this.requiresFreshLogin,
    );
  }
}
