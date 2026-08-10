import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';

class AuthState {
  const AuthState({
    this.isRegisterLoading = false,
    this.isRegisterSuccess = false,
    this.register,
    this.errorMessage,
    this.failure,
  });

  final bool isRegisterLoading;
  final bool isRegisterSuccess;
  final RegisterEntity? register;
  final String? errorMessage;
  final Failure? failure;

  AuthState copyWith({
    bool? isRegisterLoading,
    bool? isRegisterSuccess,
    RegisterEntity? register,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return AuthState(
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isRegisterSuccess: isRegisterSuccess ?? this.isRegisterSuccess,
      register: register ?? this.register,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
