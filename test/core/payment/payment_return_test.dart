import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';

void main() {
  group('parsePaymentReturn', () {
    test('parses fixed Payzah success return', () {
      final result = parsePaymentReturn(
        Uri.parse('mealmate://checkout/success?paymentId=pz-track-123'),
      );
      expect(result?.destination, PaymentReturnDestination.success);
      expect(result?.paymentId, 'pz-track-123');
    });

    test('parses fixed Payzah error return', () {
      final result = parsePaymentReturn(
        Uri.parse('mealmate://checkout/error?paymentId=pz-track-123'),
      );
      expect(result?.destination, PaymentReturnDestination.error);
      expect(result?.paymentId, 'pz-track-123');
    });

    test('parses fixed Payzah pending return', () {
      final result = parsePaymentReturn(
        Uri.parse('mealmate://checkout/pending?paymentId=pz-track-123'),
      );
      expect(result?.destination, PaymentReturnDestination.pending);
      expect(result?.paymentId, 'pz-track-123');
    });

    test('parses fixed Payzah review return', () {
      final result = parsePaymentReturn(
        Uri.parse('mealmate://checkout/review?paymentId=pz-track-123'),
      );
      expect(result?.destination, PaymentReturnDestination.review);
      expect(result?.paymentId, 'pz-track-123');
    });

    test('rejects an unrelated custom-scheme link (fake host)', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://attacker/success?paymentId=pz-track-123'),
        ),
        isNull,
      );
    });

    test('rejects wrong scheme (https, http, ftp)', () {
      expect(
        parsePaymentReturn(
          Uri.parse('https://checkout/success?paymentId=pz-track-123'),
        ),
        isNull,
      );
      expect(
        parsePaymentReturn(
          Uri.parse('http://checkout/success?paymentId=pz-track-123'),
        ),
        isNull,
      );
    });

    test('rejects extra path segments', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success/more?paymentId=pz-track-123'),
        ),
        isNull,
      );
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/v1/success?paymentId=pz-track-123'),
        ),
        isNull,
      );
    });

    test('rejects missing or empty paymentId', () {
      expect(
        parsePaymentReturn(Uri.parse('mealmate://checkout/success')),
        isNull,
      );
      expect(
        parsePaymentReturn(Uri.parse('mealmate://checkout/success?paymentId=')),
        isNull,
      );
    });

    test('rejects duplicated identifiers', () {
      expect(
        parsePaymentReturn(
          Uri.parse(
            'mealmate://checkout/success?paymentId=pz-a&paymentId=pz-b',
          ),
        ),
        isNull,
      );
    });

    test('rejects provider PaymentID without pz- prefix', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success?paymentId=12345678'),
        ),
        isNull,
      );
    });

    test('rejects pz- prefix with empty suffix', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success?paymentId=pz-'),
        ),
        isNull,
      );
    });

    test('rejects userinfo and explicit port', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://user:pass@checkout/success?paymentId=pz-123'),
        ),
        isNull,
      );
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout:8080/success?paymentId=pz-123'),
        ),
        isNull,
      );
    });

    test('rejects URI with fragment', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success?paymentId=pz-123#fragment'),
        ),
        isNull,
      );
    });

    test('rejects control characters or excessively long paymentId', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success?paymentId=pz-track%0Aevil'),
        ),
        isNull,
      );
      final excessivelyLong = 'pz-${'a' * 300}';
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/success?paymentId=$excessivelyLong'),
        ),
        isNull,
      );
    });

    test('never consumes arbitrary "to" parameter as destination', () {
      final result = parsePaymentReturn(
        Uri.parse(
          'mealmate://checkout/success?paymentId=pz-123&to=https://evil.com',
        ),
      );
      // Valid success destination, but "to" is completely ignored
      expect(result?.destination, PaymentReturnDestination.success);
      expect(result?.paymentId, 'pz-123');
    });

    test('rejects unknown destination path', () {
      expect(
        parsePaymentReturn(
          Uri.parse('mealmate://checkout/unknown?paymentId=pz-123'),
        ),
        isNull,
      );
    });
  });
}
