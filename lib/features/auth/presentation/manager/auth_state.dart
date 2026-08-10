import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';

class AuthState {
  const AuthState({
    this.isRegisterLoading = false,
    this.isRegisterSuccess = false,
    this.isCallingCodesLoading = false,
    this.isCallingCodesSuccess = false,
    this.callingCodes = const [],
    this.selectedCallingCode,
    this.register,
    this.errorMessage,
    this.failure,
    this.callingCodesFailure,
  });

  final bool isRegisterLoading;
  final bool isRegisterSuccess;
  final bool isCallingCodesLoading;
  final bool isCallingCodesSuccess;
  final List<CallingCodeEntity> callingCodes;
  final CallingCodeEntity? selectedCallingCode;
  final RegisterEntity? register;
  final String? errorMessage;
  final Failure? failure;
  final Failure? callingCodesFailure;

  AuthState copyWith({
    bool? isRegisterLoading,
    bool? isRegisterSuccess,
    bool? isCallingCodesLoading,
    bool? isCallingCodesSuccess,
    List<CallingCodeEntity>? callingCodes,
    CallingCodeEntity? selectedCallingCode,
    RegisterEntity? register,
    String? errorMessage,
    Failure? failure,
    Failure? callingCodesFailure,
    bool clearError = false,
    bool clearCallingCodesFailure = false,
  }) {
    return AuthState(
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isRegisterSuccess: isRegisterSuccess ?? this.isRegisterSuccess,
      isCallingCodesLoading:
          isCallingCodesLoading ?? this.isCallingCodesLoading,
      isCallingCodesSuccess:
          isCallingCodesSuccess ?? this.isCallingCodesSuccess,
      callingCodes: callingCodes ?? this.callingCodes,
      selectedCallingCode: selectedCallingCode ?? this.selectedCallingCode,
      register: register ?? this.register,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
      callingCodesFailure: clearCallingCodesFailure
          ? null
          : callingCodesFailure ?? this.callingCodesFailure,
    );
  }
}
