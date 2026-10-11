import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/payment/payment_navigation.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  group('isValidInitialPaymentUrl', () {
    test('accepts valid HTTPS url with host', () {
      expect(
        isValidInitialPaymentUrl('https://payzah.net/checkout/12345'),
        isTrue,
      );
      expect(
        isValidInitialPaymentUrl('https://payments.example.com/pay'),
        isTrue,
      );
    });

    test('rejects HTTP url', () {
      expect(isValidInitialPaymentUrl('http://payzah.net/checkout'), isFalse);
    });

    test('rejects javascript, data, file schemes', () {
      expect(isValidInitialPaymentUrl('javascript:alert(1)'), isFalse);
      expect(isValidInitialPaymentUrl('data:text/html,<html></html>'), isFalse);
      expect(isValidInitialPaymentUrl('file:///etc/passwd'), isFalse);
    });

    test('rejects empty host, relative url, or userinfo', () {
      expect(isValidInitialPaymentUrl('https:///checkout'), isFalse);
      expect(isValidInitialPaymentUrl('/checkout/relative'), isFalse);
      expect(
        isValidInitialPaymentUrl('https://user:pass@example.com/checkout'),
        isFalse,
      );
    });
  });

  group('handlePaymentNavigation', () {
    test('backend return navigates normally without interception', () {
      final uri = Uri.parse(
        'https://maelmate.runasp.net/api/v1/payments/payzah/return?trackId=pz-12345',
      );
      final result = handlePaymentNavigation(uri);
      expect(result.decision, NavigationDecision.navigate);
      expect(result.paymentReturn, isNull);
    });

    test('valid custom return prevents navigation and emits PaymentReturn', () {
      final uri = Uri.parse(
        'mealmate://checkout/success?paymentId=pz-track-abc',
      );
      final result = handlePaymentNavigation(uri);
      expect(result.decision, NavigationDecision.prevent);
      expect(
        result.paymentReturn?.destination,
        PaymentReturnDestination.success,
      );
      expect(result.paymentReturn?.paymentId, 'pz-track-abc');
    });

    test(
      'valid review return prevents navigation and emits review destination',
      () {
        final uri = Uri.parse(
          'mealmate://checkout/review?paymentId=pz-track-abc',
        );
        final result = handlePaymentNavigation(uri);
        expect(result.decision, NavigationDecision.prevent);
        expect(
          result.paymentReturn?.destination,
          PaymentReturnDestination.review,
        );
        expect(result.paymentReturn?.paymentId, 'pz-track-abc');
      },
    );

    test(
      'unrelated custom schemes prevent navigation without emitting payment return',
      () {
        final intentUri = Uri.parse('intent://scan/#Intent;scheme=zxing;end');
        final intentResult = handlePaymentNavigation(intentUri);
        expect(intentResult.decision, NavigationDecision.prevent);
        expect(intentResult.paymentReturn, isNull);

        final telUri = Uri.parse('tel:+123456789');
        final telResult = handlePaymentNavigation(telUri);
        expect(telResult.decision, NavigationDecision.prevent);
        expect(telResult.paymentReturn, isNull);
      },
    );

    test(
      'invalid mealmate scheme link prevents navigation without emitting return',
      () {
        final attackerUri = Uri.parse(
          'mealmate://attacker/success?paymentId=pz-123',
        );
        final result = handlePaymentNavigation(attackerUri);
        expect(result.decision, NavigationDecision.prevent);
        expect(result.paymentReturn, isNull);
      },
    );

    test('legacy /api/v1/payments/myfatoorah is not intercepted as success', () {
      final legacyUri = Uri.parse(
        'https://maelmate.runasp.net/api/v1/payments/myfatoorah?to=mealmate://checkout/success',
      );
      final result = handlePaymentNavigation(legacyUri);
      // It navigates normally as an HTTPS URL; no client-side success interception!
      expect(result.decision, NavigationDecision.navigate);
      expect(result.paymentReturn, isNull);
    });
  });
}
