import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';

class AuthState {
  const AuthState({
    this.login = const LoginState(),
    this.register = const RegisterState(),
    this.callingCodes = const CallingCodesState(),
    this.verifyPhone = const VerifyPhoneState(),
    this.refreshToken = const RefreshTokenState(),
    this.logout = const LogoutState(),
  });

  final LoginState login;
  final RegisterState register;
  final CallingCodesState callingCodes;
  final VerifyPhoneState verifyPhone;
  final RefreshTokenState refreshToken;
  final LogoutState logout;

  AuthState copyWith({
    LoginState? login,
    RegisterState? register,
    CallingCodesState? callingCodes,
    VerifyPhoneState? verifyPhone,
    RefreshTokenState? refreshToken,
    LogoutState? logout,
  }) {
    return AuthState(
      login: login ?? this.login,
      register: register ?? this.register,
      callingCodes: callingCodes ?? this.callingCodes,
      verifyPhone: verifyPhone ?? this.verifyPhone,
      refreshToken: refreshToken ?? this.refreshToken,
      logout: logout ?? this.logout,
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
