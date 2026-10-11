import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/services/auth_refresh_service.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/refresh_token_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _data[key];

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.clear();
  }
}

class _FakeRefreshTokenUseCase extends Fake implements RefreshTokenUseCase {
  int callCount = 0;
  Completer<ApiResult<RefreshTokenEntity>>? completer;
  ApiResult<RefreshTokenEntity>? cannedResult;

  @override
  Future<ApiResult<RefreshTokenEntity>> call(
    RefreshTokenRequestEntity request,
  ) async {
    callCount++;
    if (completer != null) {
      return completer!.future;
    }
    return cannedResult!;
  }
}

enum StartupDestination { home, login, retryRequired }

Future<StartupDestination> simulateStartupFlow({
  required TokenService tokenService,
  required AuthRefreshService refreshService,
  required DateTime nowUtc,
}) async {
  final isRemembered = await tokenService.isRememberedSession();
  if (!isRemembered) {
    await tokenService.clearSession();
    return StartupDestination.login;
  }

  final isExpired = tokenService.isAccessTokenExpired(now: nowUtc);
  if (!isExpired) {
    return StartupDestination.home;
  }

  final refreshToken = await tokenService.getRefreshToken();
  if (refreshToken == null || refreshToken.trim().isEmpty) {
    await tokenService.clearSession();
    return StartupDestination.login;
  }

  final result = await refreshService.refreshSession();
  if (result is ApiSuccessResult<RefreshTokenEntity>) {
    return StartupDestination.home;
  }

  if (result is ApiErrorResult<RefreshTokenEntity>) {
    final failure = result.failure;
    final isPermanent =
        failure.exception.errorType == ApiErrorType.unauthorized ||
        failure.exception.errorType == ApiErrorType.forbidden ||
        failure.exception.statusCode == 401 ||
        failure.exception.statusCode == 403;

    if (isPermanent) {
      await tokenService.clearSession();
      return StartupDestination.login;
    } else {
      return StartupDestination.retryRequired;
    }
  }

  return StartupDestination.login;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeSecureStorage secureStorage;
  late SharedPreferences prefs;
  late TokenService tokenService;
  late _FakeRefreshTokenUseCase fakeUseCase;
  late AuthRefreshService refreshService;
  final now = DateTime.utc(2026, 10, 7, 12, 0);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secureStorage = _FakeSecureStorage();
    tokenService = TokenService(prefs: secureStorage, sharedPreferences: prefs);
    fakeUseCase = _FakeRefreshTokenUseCase();
    refreshService = AuthRefreshService(
      tokenService: tokenService,
      refreshTokenUseCaseProvider: () => fakeUseCase,
    );
  });

  group('Startup routing matrix', () {
    test(
      'remembered=true, access future expiry -> route Home directly, no refresh',
      () async {
        await tokenService.saveSession(
          userId: 'user_1',
          accessToken: 'valid_access',
          refreshToken: 'valid_refresh',
          accessExpiresAtUtc: DateTime.utc(2026, 10, 7, 13, 0),
          refreshExpiresAtUtc: DateTime.utc(2026, 10, 14, 12, 0),
          persistence: SessionPersistence.remembered,
        );

        final dest = await simulateStartupFlow(
          tokenService: tokenService,
          refreshService: refreshService,
          nowUtc: now,
        );

        expect(dest, StartupDestination.home);
        expect(fakeUseCase.callCount, 0);
      },
    );

    test(
      'remembered=true, access past expiry, refresh valid -> refresh call, Home after success',
      () async {
        await tokenService.saveSession(
          userId: 'user_1',
          accessToken: 'expired_access',
          refreshToken: 'valid_refresh',
          accessExpiresAtUtc: DateTime.utc(2026, 10, 7, 11, 0),
          refreshExpiresAtUtc: DateTime.utc(2026, 10, 14, 12, 0),
          persistence: SessionPersistence.remembered,
        );

        fakeUseCase.cannedResult = const ApiSuccessResult(
          data: RefreshTokenEntity(
            userId: 'user_1',
            email: null,
            phoneNumber: '12345678',
            fullName: 'Test User',
            userType: 'customer',
            accountStatus: 'active',
            restaurantId: null,
            roles: [],
            permissions: [],
            accessToken: 'fresh_access',
            accessTokenExpiresAtUtc: '2026-10-07T14:00:00.000Z',
            refreshToken: 'fresh_refresh',
            refreshTokenExpiresAtUtc: '2026-10-14T12:00:00.000Z',
            nextStep: null,
          ),
        );

        final dest = await simulateStartupFlow(
          tokenService: tokenService,
          refreshService: refreshService,
          nowUtc: now,
        );

        expect(fakeUseCase.callCount, 1);
        expect(dest, StartupDestination.home);
      },
    );

    test(
      'remembered=false, previous run tokens -> route Login, no refresh',
      () async {
        await tokenService.saveSession(
          userId: 'user_1',
          accessToken: 'access_1',
          refreshToken: 'refresh_1',
          accessExpiresAtUtc: DateTime.utc(2026, 10, 7, 13, 0),
          refreshExpiresAtUtc: DateTime.utc(2026, 10, 14, 12, 0),
          persistence: SessionPersistence.currentRun,
        );

        final dest = await simulateStartupFlow(
          tokenService: tokenService,
          refreshService: refreshService,
          nowUtc: now,
        );

        expect(dest, StartupDestination.login);
        expect(fakeUseCase.callCount, 0);
        expect(await tokenService.getToken(), isNull);
      },
    );

    test('refresh timeout / offline -> tokens intact, retryRequired', () async {
      await tokenService.saveSession(
        userId: 'user_1',
        accessToken: 'expired_access',
        refreshToken: 'valid_refresh',
        accessExpiresAtUtc: DateTime.utc(2026, 10, 7, 11, 0),
        refreshExpiresAtUtc: DateTime.utc(2026, 10, 14, 12, 0),
        persistence: SessionPersistence.remembered,
      );

      fakeUseCase.cannedResult = ApiErrorResult(
        failure: Failure.fromException(
          const ApiException(
            errorType: ApiErrorType.connectionTimeout,
            message: 'Connection timed out',
          ),
        ),
      );

      final dest = await simulateStartupFlow(
        tokenService: tokenService,
        refreshService: refreshService,
        nowUtc: now,
      );

      expect(dest, StartupDestination.retryRequired);
      expect(await tokenService.getToken(), 'expired_access');
      expect(await tokenService.getRefreshToken(), 'valid_refresh');
    });

    test(
      'refresh permanently rejected -> clears session, route Login',
      () async {
        await tokenService.saveSession(
          userId: 'user_1',
          accessToken: 'expired_access',
          refreshToken: 'revoked_refresh',
          accessExpiresAtUtc: DateTime.utc(2026, 10, 7, 11, 0),
          refreshExpiresAtUtc: DateTime.utc(2026, 10, 14, 12, 0),
          persistence: SessionPersistence.remembered,
        );

        fakeUseCase.cannedResult = ApiErrorResult(
          failure: Failure.fromException(
            const ApiException(
              errorType: ApiErrorType.unauthorized,
              message: 'Refresh token invalid or expired',
              statusCode: 401,
            ),
          ),
        );

        final dest = await simulateStartupFlow(
          tokenService: tokenService,
          refreshService: refreshService,
          nowUtc: now,
        );

        expect(dest, StartupDestination.login);
        expect(await tokenService.getToken(), isNull);
        expect(await tokenService.getRefreshToken(), isNull);
      },
    );
  });
}
