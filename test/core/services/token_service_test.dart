import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/utils/constants.dart';
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
  }) async {
    return _data[key];
  }

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeSecureStorage secureStorage;
  late SharedPreferences prefs;
  late TokenService tokenService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secureStorage = _FakeSecureStorage();
    tokenService = TokenService(
      prefs: secureStorage,
      sharedPreferences: prefs,
    );
  });

  group('TokenService - Session persistence and remember', () {
    test('saveSession with remembered stores tokens, expiry UTC, and marks isRememberedSession', () async {
      final accessExpiry = DateTime.utc(2026, 12, 1, 10, 0);
      final refreshExpiry = DateTime.utc(2026, 12, 15, 10, 0);

      await tokenService.saveSession(
        userId: 'user_123',
        accessToken: 'access_abc',
        refreshToken: 'refresh_xyz',
        accessExpiresAtUtc: accessExpiry,
        refreshExpiresAtUtc: refreshExpiry,
        persistence: SessionPersistence.remembered,
      );

      expect(await tokenService.getToken(), 'access_abc');
      expect(await tokenService.getRefreshToken(), 'refresh_xyz');
      expect(await tokenService.getCurrentUserId(), 'user_123');
      expect(await tokenService.isRememberedSession(), isTrue);
      expect(tokenService.getAccessExpiresAtUtc(), accessExpiry);
      expect(tokenService.getRefreshExpiresAtUtc(), refreshExpiry);
    });

    test('saveSession with currentRun keeps session tokens but isRememberedSession is false', () async {
      await tokenService.saveSession(
        userId: 'user_123',
        accessToken: 'access_abc',
        refreshToken: 'refresh_xyz',
        accessExpiresAtUtc: null,
        refreshExpiresAtUtc: null,
        persistence: SessionPersistence.currentRun,
      );

      expect(await tokenService.getToken(), 'access_abc');
      expect(await tokenService.isRememberedSession(), isFalse);
    });

    test('remembered session survives service recreation', () async {
      await tokenService.saveSession(
        userId: 'user_123',
        accessToken: 'access_abc',
        refreshToken: 'refresh_xyz',
        accessExpiresAtUtc: null,
        refreshExpiresAtUtc: null,
        persistence: SessionPersistence.remembered,
      );

      final freshService = TokenService(
        prefs: secureStorage,
        sharedPreferences: prefs,
      );

      expect(await freshService.isRememberedSession(), isTrue);
      expect(await freshService.getToken(), 'access_abc');
      expect(await freshService.getCurrentUserId(), 'user_123');
    });

    test('flags true with empty secure storage tokens is not a valid session', () async {
      await prefs.setBool(AppConstants.isRemember, true);
      await prefs.setBool(AppConstants.isAccessTokenSaved, true);
      await prefs.setBool(AppConstants.isRefreshTokenSaved, true);
      await prefs.setString(AppConstants.customerIdKey, 'user_123');
      // No tokens in secureStorage

      expect(await tokenService.getToken(), isNull);
      expect(await tokenService.getRefreshToken(), isNull);
      expect(await tokenService.isRememberedSession(), isFalse);
    });

    test('saveSession throws and does not commit when required fields are empty', () async {
      expect(
        () => tokenService.saveSession(
          userId: '',
          accessToken: 'token',
          refreshToken: 'refresh',
          accessExpiresAtUtc: null,
          refreshExpiresAtUtc: null,
          persistence: SessionPersistence.remembered,
        ),
        throwsArgumentError,
      );
      expect(await tokenService.isRememberedSession(), isFalse);
      expect(await tokenService.getToken(), isNull);
    });

    test('clearSession clears session tokens and metadata without deleting biometric credentials', () async {
      await tokenService.saveSession(
        userId: 'user_123',
        accessToken: 'access_abc',
        refreshToken: 'refresh_xyz',
        accessExpiresAtUtc: DateTime.utc(2026, 12, 1),
        refreshExpiresAtUtc: DateTime.utc(2026, 12, 15),
        persistence: SessionPersistence.remembered,
      );
      await tokenService.saveBiometricCredentials(
        phone: '12345678',
        password: 'secure_password',
        countryCode: '+965',
      );

      await tokenService.clearSession();

      expect(await tokenService.getToken(), isNull);
      expect(await tokenService.getRefreshToken(), isNull);
      expect(await tokenService.getCurrentUserId(), isNull);
      expect(await tokenService.isRememberedSession(), isFalse);
      expect(tokenService.getAccessExpiresAtUtc(), isNull);

      // Biometric credentials MUST remain intact
      final bio = await tokenService.getBiometricCredentials();
      expect(bio, isNotNull);
      expect(bio?.phone, '12345678');
      expect(bio?.password, 'secure_password');
    });

    test('isAccessTokenExpired respects UTC clock', () async {
      final expiry = DateTime.utc(2026, 10, 7, 12, 0);
      await tokenService.saveSession(
        userId: 'user_123',
        accessToken: 'access_abc',
        refreshToken: 'refresh_xyz',
        accessExpiresAtUtc: expiry,
        refreshExpiresAtUtc: null,
        persistence: SessionPersistence.currentRun,
      );

      expect(
        tokenService.isAccessTokenExpired(
          now: DateTime.utc(2026, 10, 7, 11, 0),
        ),
        isFalse,
      );
      expect(
        tokenService.isAccessTokenExpired(
          now: DateTime.utc(2026, 10, 7, 13, 0),
        ),
        isTrue,
      );
    });
  });
}
