import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../biometric/biometric_credentials.dart';
import '../utils/constants.dart';

@injectable
class TokenService {
  TokenService({required this._prefs, required this._sharedPreferences});
  final FlutterSecureStorage _prefs;
  final SharedPreferences _sharedPreferences;
  // ---------------- ACCESS TOKEN ----------------

  bool get isAccessTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isAccessTokenSaved) ?? false;

  Future<void> saveAccessToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
    await _prefs.write(key: AppConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    if (!isAccessTokenSaved) return null;
    return _prefs.read(key: AppConstants.accessToken);
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
    return _prefs.read(key: AppConstants.refreshToken);
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

  Future<void> clearTokens() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteCurrentUserId();
    await _sharedPreferences.remove(StorageKeys.currentSubscriptionId);
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
