// class SensitiveDataSanitizer {
//   SensitiveDataSanitizer._();

//   static const List<String> sensitiveKeys = [
//     'password',
//     'newPassword',
//     'currentPassword',
//     'temporaryPassword',
//     'otpCode',
//     'otp',
//     'code',
//     'loginChallengeToken',
//     'challengeToken',
//     'generatedPassword',
//     'accessToken',
//     'refreshToken',
//     'token',
//     'cvv',
//     'cardNumber',
//     'paymentUrl',
//   ];

//   static final List<RegExp> _jsonKeyPatterns = sensitiveKeys.map((key) {
//     return RegExp(
//       '("$key"|\\b$key\\b)\\s*:\\s*(?:"[^"]*"|[^,\\s}\\]]+)',
//       caseSensitive: false,
//     );
//   }).toList();

//   static final List<RegExp> _queryKeyPatterns = sensitiveKeys.map((key) {
//     return RegExp('(\\b$key\\b)=([^&\\s]+)', caseSensitive: false);
//   }).toList();

//   static final RegExp _bearerPattern = RegExp(
//     r'Bearer\s+[A-Za-z0-9\-_.=]+',
//     caseSensitive: false,
//   );

//   static String sanitize(dynamic input) {
//     if (input == null) return '';
//     String text = input.toString();

//     for (final pattern in _jsonKeyPatterns) {
//       text = text.replaceAllMapped(pattern, (match) {
//         final keyPart = match.group(1) ?? '';
//         return '$keyPart: "[REDACTED]"';
//       });
//     }

//     for (final pattern in _queryKeyPatterns) {
//       text = text.replaceAllMapped(pattern, (match) {
//         final keyPart = match.group(1) ?? '';
//         return '$keyPart=[REDACTED]';
//       });
//     }

//     text = text.replaceAll(_bearerPattern, 'Bearer [REDACTED]');
//     return text;
//   }
// }
