import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/push_notification_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:meal_meat_user/features/auth/data/mapper/calling_code_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/forgot_password_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/login_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/logout_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/refresh_token_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/register_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/resend_password_otp_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/resend_phone_otp_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/reset_password_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/verify_phone_mapper.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._sharedPrefHelper,
    this._pushNotificationService,
    this._familyFlowSnapshotStore,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final SharedPrefHelper _sharedPrefHelper;
  final PushNotificationService _pushNotificationService;
  final FamilyFlowSnapshotStore _familyFlowSnapshotStore;

  @override
  Future<ApiResult<LoginEntity>> login(LoginRequestEntity request) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.login(request.toDto());
      final entity = response.toEntity();

      await _clearSubscriptionCache();
      await _saveAuthSession(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userId: entity.userId,
      );
      await _pushNotificationService.registerCurrentToken();

      return entity;
    });
  }

  @override
  Future<ApiResult<RegisterEntity>> register(RegisterRequestEntity request) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.register(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<VerifyPhoneEntity>> verifyPhone(
    VerifyPhoneRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.verifyPhone(request.toDto());
      final entity = response.toEntity();

      await _clearSubscriptionCache();
      await _saveAuthSession(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userId: entity.userId,
      );
      await _pushNotificationService.registerCurrentToken();

      return entity;
    });
  }

  @override
  Future<ApiResult<ResendPhoneOtpEntity>> resendPhoneOtp(
    ResendPhoneOtpRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.resendPhoneOtp(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ForgotPasswordEntity>> forgotPassword(
    ForgotPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.forgotPassword(request.toDto());
      return response.toEntity(request);
    });
  }

  @override
  Future<ApiResult<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.resetPassword(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ResendPasswordOtpEntity>> resendPasswordOtp(
    ResendPasswordOtpRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.resendPasswordOtp(
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<RefreshTokenEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.refreshToken(request.toDto());
      final entity = response.toEntity();

      await _saveAuthSession(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userId: entity.userId,
      );
      await _pushNotificationService.registerCurrentToken();

      return entity;
    });
  }

  @override
  Future<ApiResult<LogoutEntity>> logout(LogoutRequestEntity request) {
    return safeApiCall(() async {
      try {
        await _pushNotificationService.unregisterCurrentToken();
        await _remoteDataSource.logout(request.toDto());
      } finally {
        await _tokenService.clearTokens();
        await _clearSubscriptionCache();
      }

      return const LogoutEntity(isLoggedOut: true);
    });
  }

  @override
  Future<ApiResult<List<CallingCodeEntity>>> getCallingCodes() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCallingCodes();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  Future<void> _saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    if (accessToken.isNotEmpty) {
      await _tokenService.saveAccessToken(accessToken);
    }
    await _tokenService.saveRefreshToken(refreshToken);
    await _tokenService.saveCurrentUserId(userId);
  }

  Future<void> _clearSubscriptionCache() async {
    _familyFlowSnapshotStore.invalidate();
    await _sharedPrefHelper.removeData(key: StorageKeys.currentSubscriptionId);
  }
}
