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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeSecureStorage secureStorage;
  late SharedPreferences prefs;
  late TokenService tokenService;
  late _FakeRefreshTokenUseCase fakeUseCase;
  late AuthRefreshService refreshService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secureStorage = _FakeSecureStorage();
    tokenService = TokenService(
      prefs: secureStorage,
      sharedPreferences: prefs,
    );
    fakeUseCase = _FakeRefreshTokenUseCase();
    refreshService = AuthRefreshService(
      tokenService: tokenService,
      refreshTokenUseCaseProvider: () => fakeUseCase,
    );

    // Initial valid remembered session
    await tokenService.saveSession(
      userId: 'user_1',
      accessToken: 'old_access',
      refreshToken: 'old_refresh',
      accessExpiresAtUtc: DateTime.utc(2026, 1, 1),
      refreshExpiresAtUtc: DateTime.utc(2026, 12, 1),
      persistence: SessionPersistence.remembered,
    );
  });

  group('AuthRefreshService - Single-flight refresh', () {
    test('concurrent refresh calls result in exactly ONE network call', () async {
      fakeUseCase.completer = Completer<ApiResult<RefreshTokenEntity>>();

      final call1 = refreshService.refreshSession();
      final call2 = refreshService.refreshSession();
      final call3 = refreshService.refreshSession();

      await Future<void>.delayed(Duration.zero);
      expect(fakeUseCase.callCount, 1);

      fakeUseCase.completer!.complete(
        const ApiSuccessResult(
          data: RefreshTokenEntity(
            userId: 'user_1',
            email: 'test@example.com',
            phoneNumber: '12345678',
            fullName: 'User One',
            userType: 'customer',
            accountStatus: 'active',
            restaurantId: null,
            roles: [],
            permissions: [],
            accessToken: 'new_access',
            accessTokenExpiresAtUtc: '2026-12-01T10:00:00.000Z',
            refreshToken: 'new_refresh',
            refreshTokenExpiresAtUtc: '2026-12-15T10:00:00.000Z',
            nextStep: null,
          ),
        ),
      );

      final results = await Future.wait<ApiResult<RefreshTokenEntity>>(
        [call1, call2, call3],
      );
      expect(fakeUseCase.callCount, 1);
      for (final r in results) {
        expect(r, isA<ApiSuccessResult<RefreshTokenEntity>>());
      }
    });

    test('transient network failure retains tokens and does not clear session', () async {
      fakeUseCase.cannedResult = ApiErrorResult(
        failure: Failure.fromException(
          const ApiException(
            errorType: ApiErrorType.noInternetConnection,
            message: 'No internet',
          ),
        ),
      );

      final result = await refreshService.refreshSession();

      expect(result, isA<ApiErrorResult>());
      expect(await tokenService.getToken(), 'old_access');
      expect(await tokenService.getRefreshToken(), 'old_refresh');
      expect(await tokenService.isRememberedSession(), isTrue);
    });

    test('permanent 401 rejection clears session tokens once', () async {
      fakeUseCase.cannedResult = ApiErrorResult(
        failure: Failure.fromException(
          const ApiException(
            errorType: ApiErrorType.unauthorized,
            message: 'Invalid refresh token',
            statusCode: 401,
          ),
        ),
      );

      final result = await refreshService.refreshSession();

      expect(result, isA<ApiErrorResult>());
      expect(await tokenService.getToken(), isNull);
      expect(await tokenService.getRefreshToken(), isNull);
      expect(await tokenService.isRememberedSession(), isFalse);
    });

    test('logout during in-flight refresh discards result and does not commit tokens', () async {
      fakeUseCase.completer = Completer<ApiResult<RefreshTokenEntity>>();

      final refreshFuture = refreshService.refreshSession();
      await Future<void>.delayed(Duration.zero);
      expect(fakeUseCase.callCount, 1);

      // User performs logout while refresh is in flight
      await tokenService.clearSession();

      // Refresh completes afterwards
      fakeUseCase.completer!.complete(
        const ApiSuccessResult(
          data: RefreshTokenEntity(
            userId: 'user_1',
            email: 'test@example.com',
            phoneNumber: '12345678',
            fullName: 'User One',
            userType: 'customer',
            accountStatus: 'active',
            restaurantId: null,
            roles: [],
            permissions: [],
            accessToken: 'stale_access',
            accessTokenExpiresAtUtc: '2026-12-01T10:00:00.000Z',
            refreshToken: 'stale_refresh',
            refreshTokenExpiresAtUtc: '2026-12-15T10:00:00.000Z',
            nextStep: null,
          ),
        ),
      );

      final result = await refreshFuture;
      expect(result, isA<ApiErrorResult>());
      expect(await tokenService.getToken(), isNull);
      expect(await tokenService.getRefreshToken(), isNull);
    });
  });
}
