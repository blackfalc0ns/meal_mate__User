import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../biometric/biometric_credentials.dart';
import '../utils/constants.dart';
import 'session_persistence.dart';

@lazySingleton
class TokenService {
  TokenService({
    required FlutterSecureStorage prefs,
    required SharedPreferences sharedPreferences,
  })  : _prefs = prefs,
        _sharedPreferences = sharedPreferences;

  final FlutterSecureStorage _prefs;
  final SharedPreferences _sharedPreferences;
  int _sessionGeneration = 0;

  int get sessionGeneration => _sessionGeneration;

  void bumpSessionGeneration() {
    _sessionGeneration++;
  }

  // ---------------- ACCESS TOKEN ----------------

  bool get isAccessTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isAccessTokenSaved) ?? false;

  Future<void> saveAccessToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
    await _prefs.write(key: AppConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    if (!isAccessTokenSaved) return null;
    final token = await _prefs.read(key: AppConstants.accessToken);
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    return token;
  }

  Future<void> deleteToken() async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, false);
    await _prefs.delete(key: AppConstants.accessToken);
  }

  // ---------------- REFRESH TOKEN ----------------

  bool get isRefreshTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isRefreshTokenSaved) ?? false;

  Future<void> saveRefreshToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, true);
    await _prefs.write(key: AppConstants.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    if (!isRefreshTokenSaved) return null;
    final token = await _prefs.read(key: AppConstants.refreshToken);
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    return token;
  }

  Future<void> deleteRefreshToken() async {
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, false);
    await _prefs.delete(key: AppConstants.refreshToken);
  }

  Future<void> saveCurrentUserId(String userId) async {
    if (userId.trim().isEmpty) return;
    await _sharedPreferences.setString(AppConstants.customerIdKey, userId);
  }

  Future<String?> getCurrentUserId() async {
    final userId = _sharedPreferences.getString(AppConstants.customerIdKey);
    if (userId == null || userId.trim().isEmpty) {
      return null;
    }
    return userId;
  }

  Future<void> deleteCurrentUserId() async {
    await _sharedPreferences.remove(AppConstants.customerIdKey);
  }

  // ---------------- SESSION PERSISTENCE ----------------

  Future<void> saveSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required DateTime? accessExpiresAtUtc,
    required DateTime? refreshExpiresAtUtc,
    required SessionPersistence persistence,
  }) async {
    if (userId.trim().isEmpty ||
        accessToken.trim().isEmpty ||
        refreshToken.trim().isEmpty) {
      throw ArgumentError('Session tokens and userId must not be empty.');
    }

    await _prefs.write(key: AppConstants.accessToken, value: accessToken);
    await _prefs.write(key: AppConstants.refreshToken, value: refreshToken);

    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, true);
    await _sharedPreferences.setString(AppConstants.customerIdKey, userId);

    final isRemembered = persistence == SessionPersistence.remembered;
    await _sharedPreferences.setBool(AppConstants.isRemember, isRemembered);

    if (accessExpiresAtUtc != null) {
      await _sharedPreferences.setString(
        AppConstants.accessExpiresAtUtcKey,
        accessExpiresAtUtc.toUtc().toIso8601String(),
      );
    } else {
      await _sharedPreferences.remove(AppConstants.accessExpiresAtUtcKey);
    }

    if (refreshExpiresAtUtc != null) {
      await _sharedPreferences.setString(
        AppConstants.refreshExpiresAtUtcKey,
        refreshExpiresAtUtc.toUtc().toIso8601String(),
      );
    } else {
      await _sharedPreferences.remove(AppConstants.refreshExpiresAtUtcKey);
    }

    _sessionGeneration++;
  }

  DateTime? getAccessExpiresAtUtc() {
    final raw =
        _sharedPreferences.getString(AppConstants.accessExpiresAtUtcKey);
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }

  DateTime? getRefreshExpiresAtUtc() {
    final raw =
        _sharedPreferences.getString(AppConstants.refreshExpiresAtUtcKey);
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }

  bool isAccessTokenExpired({DateTime? now}) {
    final expiry = getAccessExpiresAtUtc();
    if (expiry == null) return false;
    final current = (now ?? DateTime.now()).toUtc();
    return current.isAfter(expiry);
  }

  bool isRefreshTokenExpired({DateTime? now}) {
    final expiry = getRefreshExpiresAtUtc();
    if (expiry == null) return false;
    final current = (now ?? DateTime.now()).toUtc();
    return current.isAfter(expiry);
  }

  Future<bool> hasValidSessionTokens() async {
    final access = await getToken();
    final refresh = await getRefreshToken();
    final userId = await getCurrentUserId();
    return access != null && refresh != null && userId != null;
  }

  Future<bool> isRememberedSession() async {
    final isRemember =
        _sharedPreferences.getBool(AppConstants.isRemember) ?? false;
    if (!isRemember) return false;
    return hasValidSessionTokens();
  }

  Future<void> clearTokens() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteCurrentUserId();
    await _sharedPreferences.remove(StorageKeys.currentSubscriptionId);
  }

  Future<void> clearSession() async {
    await clearTokens();
    await _sharedPreferences.setBool(AppConstants.isRemember, false);
    await _sharedPreferences.remove(AppConstants.accessExpiresAtUtcKey);
    await _sharedPreferences.remove(AppConstants.refreshExpiresAtUtcKey);
    _sessionGeneration++;
  }

  // ---------------- BIOMETRIC CREDENTIALS ----------------

  Future<void> saveBiometricCredentials({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    await _prefs.write(key: AppConstants.biometricPhone, value: phone);
    await _prefs.write(key: AppConstants.biometricPassword, value: password);
    await _prefs.write(
      key: AppConstants.biometricCountryCode,
      value: countryCode,
    );
  }

  Future<BiometricCredentials?> getBiometricCredentials() async {
    final phone = await _prefs.read(key: AppConstants.biometricPhone);
    final password = await _prefs.read(key: AppConstants.biometricPassword);
    final countryCode =
        await _prefs.read(key: AppConstants.biometricCountryCode) ?? 'EG';
    if (phone == null ||
        phone.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }
    return BiometricCredentials(
      phone: phone,
      password: password,
      countryCode: countryCode,
    );
  }

  Future<bool> hasBiometricCredentials() async {
    final phone = await _prefs.read(key: AppConstants.biometricPhone);
    final password = await _prefs.read(key: AppConstants.biometricPassword);
    return phone != null &&
        phone.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  Future<void> deleteBiometricCredentials() async {
    await _prefs.delete(key: AppConstants.biometricPhone);
    await _prefs.delete(key: AppConstants.biometricPassword);
    await _prefs.delete(key: AppConstants.biometricCountryCode);
  }
}
