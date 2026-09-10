import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';

void main() {
  group('CallingCodeEntity phone formatting', () {
    const kuwait = CallingCodeEntity(
      countryCode: 'KW',
      nameAr: 'الكويت',
      nameEn: 'Kuwait',
      dialCode: '+965',
      flagEmoji: '🇰🇼',
    );

    test('builds a clean international phone number from local input', () {
      expect(kuwait.formatInternationalPhone(' 5111-1111 '), '+96551111111');
    });

    test('does not duplicate a calling code already present in the input', () {
      expect(
        kuwait.formatInternationalPhone('00965 5111 1111'),
        '+96551111111',
      );
      expect(kuwait.formatInternationalPhone('+96551111111'), '+96551111111');
    });

    test(
      'accepts a complete local phone without imposing guessed prefixes',
      () {
        expect(kuwait.hasCompleteLocalPhone('41111111'), isTrue);
        expect(kuwait.hasCompleteLocalPhone('1234567'), isFalse);
      },
    );

    test('extracts local digits from a saved international number', () {
      expect(kuwait.localPhoneDigits('+965 5111 1111'), '51111111');
    });
  });
}
