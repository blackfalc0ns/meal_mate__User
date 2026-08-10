import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/get_calling_codes_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/register_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';

@injectable
class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel(this._registerUseCase, this._getCallingCodesUseCase)
    : super(const AuthState());

  final RegisterUseCase _registerUseCase;
  final GetCallingCodesUseCase _getCallingCodesUseCase;

  void doIntent(AuthEvent event) {
    switch (event) {
      case RegisterCustomerEvent():
        _register(event.request);

      case GetCallingCodesEvent():
        _getCallingCodes();

      case SelectCallingCodeEvent():
        _selectCallingCode(event.callingCode);
    }
  }

  Future<void> _register(RegisterRequestEntity request) async {
    emit(
      state.copyWith(
        isRegisterLoading: true,
        isRegisterSuccess: false,
        clearError: true,
      ),
    );

    final result = await _registerUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRegisterLoading: false,
            isRegisterSuccess: true,
            register: result.data,
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            isRegisterLoading: false,
            isRegisterSuccess: false,
            errorMessage: result.failure.errorMessage,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _getCallingCodes() async {
    emit(
      state.copyWith(
        isCallingCodesLoading: true,
        isCallingCodesSuccess: false,
        clearCallingCodesFailure: true,
      ),
    );

    final result = await _getCallingCodesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isCallingCodesLoading: false,
            isCallingCodesSuccess: true,
            callingCodes: result.data,
            selectedCallingCode: result.data.isEmpty ? null : result.data.first,
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            isCallingCodesLoading: false,
            isCallingCodesSuccess: false,
            callingCodesFailure: result.failure,
          ),
        );
    }
  }

  void _selectCallingCode(CallingCodeEntity callingCode) {
    emit(state.copyWith(selectedCallingCode: callingCode));
  }
}
