import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/get_calling_codes_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/login_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/logout_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/refresh_token_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/register_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_password_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_phone_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/verify_phone_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';

@injectable
class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel(
    this._loginUseCase,
    this._registerUseCase,
    this._getCallingCodesUseCase,
    this._verifyPhoneUseCase,
    this._resendPhoneOtpUseCase,
    this._forgotPasswordUseCase,
    this._resetPasswordUseCase,
    this._resendPasswordOtpUseCase,
    this._refreshTokenUseCase,
    this._logoutUseCase,
  ) : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCallingCodesUseCase _getCallingCodesUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final ResendPhoneOtpUseCase _resendPhoneOtpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ResendPasswordOtpUseCase _resendPasswordOtpUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final LogoutUseCase _logoutUseCase;

  void doIntent(AuthEvent event) {
    switch (event) {
      case LoginCustomerEvent():
        _login(event.request);

      case RegisterCustomerEvent():
        _register(event.request);

      case GetCallingCodesEvent():
        _getCallingCodes();

      case SelectCallingCodeEvent():
        _selectCallingCode(event.callingCode);

      case VerifyPhoneEvent():
        _verifyPhone(event.request);

      case ResendPhoneOtpEvent():
        _resendPhoneOtp(event.request);

      case ForgotPasswordEvent():
        _forgotPassword(event.request);

      case SaveResetPasswordOtpCodeEvent():
        _saveResetPasswordOtpCode(event.otpCode);

      case ResetPasswordEvent():
        _resetPassword(event.request);

      case ResendPasswordOtpEvent():
        _resendPasswordOtp(event.request);

      case RefreshTokenEvent():
        _refreshToken(event.request);

      case LogoutEvent():
        _logout(event.request);
    }
  }

  Future<void> _login(LoginRequestEntity request) async {
    emit(
      state.copyWith(
        login: state.login.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _loginUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            login: state.login.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            login: state.login.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _register(RegisterRequestEntity request) async {
    emit(
      state.copyWith(
        register: state.register.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _registerUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            register: state.register.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            register: state.register.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getCallingCodes() async {
    emit(
      state.copyWith(
        callingCodes: state.callingCodes.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getCallingCodesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            callingCodes: state.callingCodes.copyWith(
              isLoading: false,
              isSuccess: true,
              items: result.data,
              selected: result.data.isEmpty ? null : result.data.first,
              clearSelected: result.data.isEmpty,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            callingCodes: state.callingCodes.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  void _selectCallingCode(CallingCodeEntity callingCode) {
    emit(
      state.copyWith(
        callingCodes: state.callingCodes.copyWith(selected: callingCode),
      ),
    );
  }

  Future<void> _verifyPhone(VerifyPhoneRequestEntity request) async {
    emit(
      state.copyWith(
        verifyPhone: state.verifyPhone.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _verifyPhoneUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            verifyPhone: state.verifyPhone.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            verifyPhone: state.verifyPhone.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _resendPhoneOtp(ResendPhoneOtpRequestEntity request) async {
    emit(
      state.copyWith(
        resendPhoneOtp: state.resendPhoneOtp.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _resendPhoneOtpUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        final isSuccess = result.data.success && result.data.otpSent;
        emit(
          state.copyWith(
            resendPhoneOtp: state.resendPhoneOtp.copyWith(
              isLoading: false,
              isSuccess: isSuccess,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            resendPhoneOtp: state.resendPhoneOtp.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _forgotPassword(ForgotPasswordRequestEntity request) async {
    emit(
      state.copyWith(
        forgotPassword: state.forgotPassword.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _forgotPasswordUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        final isSuccess = result.data.success && result.data.otpSent;
        emit(
          state.copyWith(
            resetPasswordOtpCode: '',
            forgotPassword: state.forgotPassword.copyWith(
              isLoading: false,
              isSuccess: isSuccess,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            forgotPassword: state.forgotPassword.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  void _saveResetPasswordOtpCode(String otpCode) {
    emit(state.copyWith(resetPasswordOtpCode: otpCode));
  }

  Future<void> _resetPassword(ResetPasswordRequestEntity request) async {
    emit(
      state.copyWith(
        resetPassword: state.resetPassword.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _resetPasswordUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        final isSuccess = result.data.success && result.data.passwordReset;
        emit(
          state.copyWith(
            resetPassword: state.resetPassword.copyWith(
              isLoading: false,
              isSuccess: isSuccess,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            resetPassword: state.resetPassword.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _resendPasswordOtp(
    ResendPasswordOtpRequestEntity request,
  ) async {
    emit(
      state.copyWith(
        resendPasswordOtp: state.resendPasswordOtp.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _resendPasswordOtpUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        final isSuccess = result.data.success && result.data.otpSent;
        emit(
          state.copyWith(
            resendPasswordOtp: state.resendPasswordOtp.copyWith(
              isLoading: false,
              isSuccess: isSuccess,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            resendPasswordOtp: state.resendPasswordOtp.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _refreshToken(RefreshTokenRequestEntity request) async {
    emit(
      state.copyWith(
        refreshToken: state.refreshToken.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _refreshTokenUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            refreshToken: state.refreshToken.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            refreshToken: state.refreshToken.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _logout(LogoutRequestEntity request) async {
    emit(
      state.copyWith(
        logout: state.logout.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _logoutUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            logout: state.logout.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            logout: state.logout.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }
}
