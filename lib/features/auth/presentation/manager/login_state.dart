import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';

enum LoginOutcome { idle, success, failure }

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.outcome = LoginOutcome.idle,
    this.rememberMe = false,
    this.failure,
    this.isBiometricReady = false,
    this.biometricStatus,
    this.biometricErrorMessage,
    this.loginEntity,
    this.lastSubmittedRequestPhone,
    this.lastSubmittedRequestCountryCode,
  });

  final bool isLoading;
  final LoginOutcome outcome;
  final bool rememberMe;
  final Failure? failure;
  final bool isBiometricReady;
  final BiometricAuthStatus? biometricStatus;
  final String? biometricErrorMessage;
  final LoginEntity? loginEntity;
  final String? lastSubmittedRequestPhone;
  final String? lastSubmittedRequestCountryCode;

  bool get isSuccess => outcome == LoginOutcome.success;

  LoginState copyWith({
    bool? isLoading,
    LoginOutcome? outcome,
    bool? rememberMe,
    Failure? Function()? failure,
    bool? isBiometricReady,
    BiometricAuthStatus? Function()? biometricStatus,
    String? Function()? biometricErrorMessage,
    LoginEntity? Function()? loginEntity,
    String? Function()? lastSubmittedRequestPhone,
    String? Function()? lastSubmittedRequestCountryCode,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
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
    );
  }
}
