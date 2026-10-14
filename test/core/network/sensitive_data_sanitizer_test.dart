import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/sensitive_data_sanitizer.dart';

void main() {
  group('SensitiveDataSanitizer', () {
    test('sanitizes json fields case-insensitively', () {
      const input = '''
{
  "password": "superSecretPassword123",
  "NEWPASSWORD": "brandNewSecret456",
  "currentPassword": "oldPassword789",
  "otpCode": "654321",
  "loginChallengeToken": "challenge-token-uuid-1234",
  "generatedPassword": "temp-password-abc",
  "accessToken": "eyJh...access-token",
  "refreshToken": "eyJh...refresh-token",
  "userId": "user-valid-123",
  "phoneNumber": "+96512345678"
}
''';

      final sanitized = SensitiveDataSanitizer.sanitize(input);

      expect(sanitized, contains('"password": "[REDACTED]"'));
      expect(sanitized, contains('"NEWPASSWORD": "[REDACTED]"'));
      expect(sanitized, contains('"currentPassword": "[REDACTED]"'));
      expect(sanitized, contains('"otpCode": "[REDACTED]"'));
      expect(sanitized, contains('"loginChallengeToken": "[REDACTED]"'));
      expect(sanitized, contains('"generatedPassword": "[REDACTED]"'));
      expect(sanitized, contains('"accessToken": "[REDACTED]"'));
      expect(sanitized, contains('"refreshToken": "[REDACTED]"'));

      // Sensitive values are NOT present
      expect(sanitized, isNot(contains('superSecretPassword123')));
      expect(sanitized, isNot(contains('brandNewSecret456')));
      expect(sanitized, isNot(contains('oldPassword789')));
      expect(sanitized, isNot(contains('654321')));
      expect(sanitized, isNot(contains('challenge-token-uuid-1234')));
      expect(sanitized, isNot(contains('temp-password-abc')));

      // Non-sensitive values are preserved
      expect(sanitized, contains('"userId": "user-valid-123"'));
      expect(sanitized, contains('"phoneNumber": "+96512345678"'));
    });

    test('sanitizes query parameters case-insensitively', () {
      const input =
          'https://api.example.com/callback?otpCode=123456&loginChallengeToken=token123&userId=99';
      final sanitized = SensitiveDataSanitizer.sanitize(input);

      expect(sanitized, contains('otpCode=[REDACTED]'));
      expect(sanitized, contains('loginChallengeToken=[REDACTED]'));
      expect(sanitized, contains('userId=99'));
    });

    test('sanitizes Authorization Bearer tokens case-insensitively', () {
      const input = 'Headers: {authorization: Bearer mySecretToken.123_xyz}';
      final sanitized = SensitiveDataSanitizer.sanitize(input);

      expect(sanitized, contains('Bearer [REDACTED]'));
      expect(sanitized, isNot(contains('mySecretToken.123_xyz')));
    });

    test('handles null input safely', () {
      expect(SensitiveDataSanitizer.sanitize(null), '');
    });
  });
}
