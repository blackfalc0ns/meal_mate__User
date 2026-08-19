/// Application-wide storage key constants used by the network/auth layer.
abstract class AppConstants {
  // 🔹 Shared Preferences / Secure Storage Keys
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String isAccessTokenSaved = 'isAccessTokenSaved';
  static const String isRefreshTokenSaved = 'isRefreshTokenSaved';
  static const String isRemember = 'isRemember';
  static const String deviceIdKey = 'deviceIdKey';
  static const String customerIdKey = 'customerIdKey';
  static const String biometricEnabled = 'biometricEnabled';

  // 🔹 Localization Keys
  static const String languageCode = 'languageCode';
  static const String arKey = 'ar';
  static const String enKey = 'en';
}
