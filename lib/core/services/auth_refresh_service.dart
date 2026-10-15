import 'dart:async';

import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/refresh_token_usecase.dart';

typedef RefreshTokenUseCaseProvider = RefreshTokenUseCase Function();

class AuthRefreshService {
  AuthRefreshService({
    required TokenService tokenService,
    required RefreshTokenUseCaseProvider refreshTokenUseCaseProvider,
  }) : _tokenService = tokenService,
       _refreshTokenUseCaseProvider = refreshTokenUseCaseProvider;

  final TokenService _tokenService;
  final RefreshTokenUseCaseProvider _refreshTokenUseCaseProvider;

  Future<ApiResult<RefreshTokenEntity>>? _inFlightRefresh;

  Future<ApiResult<RefreshTokenEntity>> refreshSession() {
    if (_inFlightRefresh != null) {
      return _inFlightRefresh!;
    }

    final future = _doRefreshSession();
    _inFlightRefresh = future;
    return future.whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<ApiResult<RefreshTokenEntity>> _doRefreshSession() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      final failure = Failure.fromException(
        const ApiException(
          errorType: ApiErrorType.unauthorized,
          message: 'No refresh token available in storage',
          statusCode: 401,
        ),
      );
      await _tokenService.clearSession();
      return ApiErrorResult(failure: failure);
    }

    final startGeneration = _tokenService.sessionGeneration;
    final useCase = _refreshTokenUseCaseProvider();
    final result = await useCase(
      RefreshTokenRequestEntity(refreshToken: refreshToken),
    );

    // If session was invalidated or replaced while refresh was in flight, discard the result.
    if (_tokenService.sessionGeneration != startGeneration) {
      final failure = Failure.fromException(
        const ApiException(
          errorType: ApiErrorType.unauthorized,
          message:
              'Session generation mismatch; session invalidated during refresh',
          statusCode: 401,
        ),
      );
      return ApiErrorResult(failure: failure);
    }

    if (result is ApiErrorResult<RefreshTokenEntity>) {
      final failure = result.failure;
      if (_isPermanentRejection(failure)) {
        await _tokenService.clearSession();
      }
    }

    return result;
  }

  bool _isPermanentRejection(Failure failure) {
    final type = failure.exception.errorType;
    final status = failure.exception.statusCode;
    return type == ApiErrorType.unauthorized ||
        type == ApiErrorType.forbidden ||
        status == 401 ||
        status == 403;
  }
}
