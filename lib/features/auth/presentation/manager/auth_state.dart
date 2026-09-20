import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_credentials.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';

class AuthState {
  const AuthState({
    this.login = const LoginState(),
    this.register = const RegisterState(),
    this.callingCodes = const CallingCodesState(),
    this.verifyPhone = const VerifyPhoneState(),
    this.resendPhoneOtp = const ResendPhoneOtpState(),
    this.forgotPassword = const ForgotPasswordState(),
    this.resetPasswordOtpCode = '',
    this.resetPassword = const ResetPasswordState(),
    this.resendPasswordOtp = const ResendPasswordOtpState(),
    this.refreshToken = const RefreshTokenState(),
    this.logout = const LogoutState(),
    this.biometric = const BiometricAuthState(),
  });

  final LoginState login;
  final RegisterState register;
  final CallingCodesState callingCodes;
  final VerifyPhoneState verifyPhone;
  final ResendPhoneOtpState resendPhoneOtp;
  final ForgotPasswordState forgotPassword;
  final String resetPasswordOtpCode;
  final ResetPasswordState resetPassword;
  final ResendPasswordOtpState resendPasswordOtp;
  final RefreshTokenState refreshToken;
  final LogoutState logout;
  final BiometricAuthState biometric;

  AuthState copyWith({
    LoginState? login,
    RegisterState? register,
    CallingCodesState? callingCodes,
    VerifyPhoneState? verifyPhone,
    ResendPhoneOtpState? resendPhoneOtp,
    ForgotPasswordState? forgotPassword,
    String? resetPasswordOtpCode,
    ResetPasswordState? resetPassword,
    ResendPasswordOtpState? resendPasswordOtp,
    RefreshTokenState? refreshToken,
    LogoutState? logout,
    BiometricAuthState? biometric,
  }) {
    return AuthState(
      login: login ?? this.login,
      register: register ?? this.register,
      callingCodes: callingCodes ?? this.callingCodes,
      verifyPhone: verifyPhone ?? this.verifyPhone,
      resendPhoneOtp: resendPhoneOtp ?? this.resendPhoneOtp,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      resetPasswordOtpCode: resetPasswordOtpCode ?? this.resetPasswordOtpCode,
      resetPassword: resetPassword ?? this.resetPassword,
      resendPasswordOtp: resendPasswordOtp ?? this.resendPasswordOtp,
      refreshToken: refreshToken ?? this.refreshToken,
      logout: logout ?? this.logout,
      biometric: biometric ?? this.biometric,
    );
  }
}

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final LoginEntity? data;
  final String? errorMessage;
  final Failure? failure;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    LoginEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final RegisterEntity? data;
  final String? errorMessage;
  final Failure? failure;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    RegisterEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class CallingCodesState {
  const CallingCodesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.items = const [],
    this.selected,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<CallingCodeEntity> items;
  final CallingCodeEntity? selected;
  final Failure? failure;

  CallingCodesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<CallingCodeEntity>? items,
    CallingCodeEntity? selected,
    Failure? failure,
    bool clearFailure = false,
    bool clearSelected = false,
  }) {
    return CallingCodesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      items: items ?? this.items,
      selected: clearSelected ? null : selected ?? this.selected,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class VerifyPhoneState {
  const VerifyPhoneState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final VerifyPhoneEntity? data;
  final String? errorMessage;
  final Failure? failure;

  VerifyPhoneState copyWith({
    bool? isLoading,
    bool? isSuccess,
    VerifyPhoneEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return VerifyPhoneState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class ResendPhoneOtpState {
  const ResendPhoneOtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final ResendPhoneOtpEntity? data;
  final String? errorMessage;
  final Failure? failure;

  ResendPhoneOtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ResendPhoneOtpEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return ResendPhoneOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class ForgotPasswordState {
  const ForgotPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final ForgotPasswordEntity? data;
  final String? errorMessage;
  final Failure? failure;

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ForgotPasswordEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class ResetPasswordState {
  const ResetPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final ResetPasswordEntity? data;
  final String? errorMessage;
  final Failure? failure;

  ResetPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ResetPasswordEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class ResendPasswordOtpState {
  const ResendPasswordOtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final ResendPasswordOtpEntity? data;
  final String? errorMessage;
  final Failure? failure;

  ResendPasswordOtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ResendPasswordOtpEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return ResendPasswordOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class RefreshTokenState {
  const RefreshTokenState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final RefreshTokenEntity? data;
  final String? errorMessage;
  final Failure? failure;

  RefreshTokenState copyWith({
    bool? isLoading,
    bool? isSuccess,
    RefreshTokenEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return RefreshTokenState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class LogoutState {
  const LogoutState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final LogoutEntity? data;
  final String? errorMessage;
  final Failure? failure;

  LogoutState copyWith({
    bool? isLoading,
    bool? isSuccess,
    LogoutEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class BiometricAuthState {
  const BiometricAuthState({
    this.isSupported = false,
    this.isEnabled = false,
    this.canOfferBiometric = false,
    this.biometricType = BiometricTypeEnum.none,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.authStatus,
    this.savedCredentials,
  });

  final bool isSupported;
  final bool isEnabled;
  final bool canOfferBiometric;
  final BiometricTypeEnum biometricType;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final BiometricAuthStatus? authStatus;
  final BiometricCredentials? savedCredentials;

  IconData get biometricIcon => switch (biometricType) {
        BiometricTypeEnum.face => Icons.face_rounded,
        BiometricTypeEnum.fingerprint => Icons.fingerprint_rounded,
        _ => Icons.fingerprint_rounded,
      };

  String getBiometricButtonText(AppLocalizations l10n) =>
      switch (biometricType) {
        BiometricTypeEnum.face =>
          '${l10n.biometric_quick_login} (${l10n.biometric_face_id})',
        BiometricTypeEnum.fingerprint =>
          '${l10n.biometric_quick_login} (${l10n.biometric_fingerprint})',
        _ => l10n.biometric_quick_login,
      };

  BiometricAuthState copyWith({
    bool? isSupported,
    bool? isEnabled,
    bool? canOfferBiometric,
    BiometricTypeEnum? biometricType,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    BiometricAuthStatus? authStatus,
    bool clearAuthStatus = false,
    BiometricCredentials? savedCredentials,
    bool clearSavedCredentials = false,
  }) {
    return BiometricAuthState(
      isSupported: isSupported ?? this.isSupported,
      isEnabled: isEnabled ?? this.isEnabled,
      canOfferBiometric: canOfferBiometric ?? this.canOfferBiometric,
      biometricType: biometricType ?? this.biometricType,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      authStatus: clearAuthStatus ? null : (authStatus ?? this.authStatus),
      savedCredentials: clearSavedCredentials
          ? null
          : (savedCredentials ?? this.savedCredentials),
    );
  }
}
