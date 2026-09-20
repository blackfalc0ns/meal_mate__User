import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
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
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';

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
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper, [
    BiometricService? biometricService,
  ])  : _biometricService = biometricService ?? getIt<BiometricService>(),
        super(const AuthState());

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
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;
  final BiometricService _biometricService;

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

      case InitBiometricEvent():
        _initBiometric();

      case AuthenticateWithBiometricEvent():
        _authenticateWithBiometric(
          localizedReason: event.localizedReason,
          lockedOutMessage: event.lockedOutMessage,
          permanentlyLockedOutMessage: event.permanentlyLockedOutMessage,
          notEnrolledMessage: event.notEnrolledMessage,
          genericErrorMessage: event.genericErrorMessage,
        );
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
        await _syncCurrentSubscriptionCache();
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
        await _syncCurrentSubscriptionCache();
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

  Future<void> _syncCurrentSubscriptionCache() async {
    final result = await _getCurrentCustomerSubscriptionUseCase();
    switch (result) {
      case ApiSuccessResult():
        final subscriptionId = result.data.subscription?.subscriptionId ?? '';
        if (subscriptionId.isEmpty) {
          await _sharedPrefHelper.removeData(
            key: StorageKeys.currentSubscriptionId,
          );
          return;
        }
        await _sharedPrefHelper.saveData(
          key: StorageKeys.currentSubscriptionId,
          val: subscriptionId,
        );
      case ApiErrorResult():
        await _sharedPrefHelper.removeData(
          key: StorageKeys.currentSubscriptionId,
        );
    }
  }

  Future<void> _initBiometric() async {
    final isSupported = await _biometricService.isDeviceSupported();
    final biometricType = await _biometricService.getPrimaryBiometricType();
    final isEnabled = _biometricService.isBiometricEnabled();
    final canOffer = await _biometricService.canOfferBiometricLogin();
    final savedCreds = await _biometricService.getSavedCredentials();

    emit(
      state.copyWith(
        biometric: state.biometric.copyWith(
          isSupported: isSupported,
          biometricType: biometricType,
          isEnabled: isEnabled,
          canOfferBiometric: canOffer,
          savedCredentials: savedCreds,
        ),
      ),
    );
  }

  Future<void> _authenticateWithBiometric({
    required String localizedReason,
    String? lockedOutMessage,
    String? permanentlyLockedOutMessage,
    String? notEnrolledMessage,
    String? genericErrorMessage,
  }) async {
    if (state.biometric.isLoading || state.login.isLoading) return;

    emit(
      state.copyWith(
        biometric: state.biometric.copyWith(
          isLoading: true,
          clearError: true,
          clearAuthStatus: true,
          isSuccess: false,
        ),
      ),
    );

    final result = await _biometricService.authenticate(
      localizedReason: localizedReason,
    );

    if (result.isSuccess) {
      await _biometricService.setBiometricEnabled(true);
      final savedCreds = await _biometricService.getSavedCredentials();
      emit(
        state.copyWith(
          biometric: state.biometric.copyWith(
            isLoading: false,
            isSuccess: true,
            authStatus: BiometricAuthStatus.success,
            savedCredentials: savedCreds,
            clearError: true,
          ),
        ),
      );

      if (savedCreds != null) {
        await _login(
          LoginRequestEntity(
            phone: savedCreds.phone,
            password: savedCreds.password,
            countryCode: savedCreds.countryCode,
          ),
        );
      } else {
        emit(
          state.copyWith(
            biometric: state.biometric.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage:
                  'يرجى تسجيل الدخول برقم الجوال وكلمة المرور لمرة واحدة لربط البصمة بأمان',
            ),
          ),
        );
      }
    } else {
      String? message;
      if (result.status == BiometricAuthStatus.lockedOut) {
        message = lockedOutMessage ?? 'Biometric authentication is temporarily locked.';
      } else if (result.status == BiometricAuthStatus.permanentlyLockedOut) {
        message = permanentlyLockedOutMessage ??
            lockedOutMessage ??
            'Biometric authentication is permanently locked.';
      } else if (result.status == BiometricAuthStatus.notEnrolled) {
        message = notEnrolledMessage ?? 'No biometrics enrolled on this device.';
      } else if (result.status != BiometricAuthStatus.canceled) {
        message = genericErrorMessage ?? result.errorMessage ?? 'Authentication failed.';
      }

      emit(
        state.copyWith(
          biometric: state.biometric.copyWith(
            isLoading: false,
            isSuccess: false,
            authStatus: result.status,
            errorMessage: message,
          ),
        ),
      );
    }
  }
}
