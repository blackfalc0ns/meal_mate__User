abstract class NetworkConstants {
  static const String baseUrl = "http://maelmate.runasp.net";
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
}

abstract class EndPoints {
  static const String login = '/api/v1/auth/customers/login';
  static const String register = '/api/v1/auth/customers/register';
  static const String verifyPhone = '/api/v1/auth/customers/verify-phone';
  static const String resendPhoneOtp =
      '/api/v1/auth/customers/resend-phone-otp';
  static const String forgotPassword = '/api/v1/auth/customers/forgot-password';
  static const String resetPassword = '/api/v1/auth/customers/reset-password';
  static const String resendPasswordOtp =
      '/api/v1/auth/customers/resend-password-otp';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String callingCodes = '/api/v1/catalog/calling-codes';
}
