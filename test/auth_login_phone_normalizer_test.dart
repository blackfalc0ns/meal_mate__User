import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_sign_in_page.dart';

void main() {
  group('normalizeLoginPhone', () {
    test('adds the dial code directly before a local phone number', () {
      expect(normalizeLoginPhone('1095959595', '+965'), '+9651095959595');
    });

    test(
      'removes the selected dial code from a pasted international number',
      () {
        expect(
          normalizeLoginPhone('+965 1095959595', '+965'),
          '+9651095959595',
        );
      },
    );

    test('removes formatting characters from the phone number', () {
      expect(normalizeLoginPhone('109 595-9595', '+965'), '+9651095959595');
    });
  });
}
