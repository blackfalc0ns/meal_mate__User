/// ─────────────────────────────────────────────────────────────
/// App‑wide constants. Values that NEVER change at runtime.
/// ─────────────────────────────────────────────────────────────
class AppConstants {
  AppConstants._();

  // ── App info ──
  static const String appName = '';
  static const String appNameAr = '';
  static const String packageName = '';
  static const String appVersion = '1.0.0';
  static const String developerEmail = '';
  static const String developerWhatsapp = '966500000000';
  static const String developerPhone = '966500000000';

  // ── Network ──
  static const int connectTimeout = 30; // seconds
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  static const int maxRetries = 3;

  // ── Pagination ──
  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  // ── Cache ──
  static const int cacheMaxAge = 7; // days

  // ── Input limits ──
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;

  // ── Animation durations ──
  static const tabSwitchDuration = Duration(milliseconds: 300);
  static const subtitleSwitchDuration = Duration(milliseconds: 250);
  static const pillAnimationDuration = Duration(milliseconds: 300);

  // ── UI Dimensions ──
  static const double logoHeight = 52.0;
  static const double toggleHeight = 50.0;
  static const double togglePadding = 3.0;
}
