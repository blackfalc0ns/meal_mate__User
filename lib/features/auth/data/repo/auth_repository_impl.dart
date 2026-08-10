import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:meal_meat_user/features/auth/data/mapper/calling_code_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/login_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/logout_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/refresh_token_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/register_mapper.dart';
import 'package:meal_meat_user/features/auth/data/mapper/verify_phone_mapper.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._tokenService);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  @override
  Future<ApiResult<LoginEntity>> login(LoginRequestEntity request) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.login(request.toDto());
      final entity = response.toEntity();

      await _saveAuthSession(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userId: entity.userId,
      );

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

      await _saveAuthSession(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userId: entity.userId,
      );

      return entity;
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

      return entity;
    });
  }

  @override
  Future<ApiResult<LogoutEntity>> logout(LogoutRequestEntity request) {
    return safeApiCall(() async {
      await _remoteDataSource.logout(request.toDto());
      await _tokenService.clearTokens();

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
}
