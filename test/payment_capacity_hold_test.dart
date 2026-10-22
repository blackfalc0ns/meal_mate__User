import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_hold_clock.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';

void main() {
  test('checkout and resume preserve authoritative server hold metadata', () {
    final json = <String, dynamic>{
      'subscriptionId': 'subscription',
      'paymentUrl': 'https://example.com/pay',
      'holdExpiresAtUtc': '2026-10-21T12:15:00Z',
      'serverTimeUtc': '2026-10-21T12:00:00Z',
    };
    final checkout = PaymentCheckoutResponseDto.fromJson(json).toEntity();
    expect(checkout.serverTimeUtc, DateTime.utc(2026, 10, 21, 12));
    expect(checkout.holdExpiresAtUtc, json['holdExpiresAtUtc']);
    final resume = SubscriptionBillingResumeResponseDto.fromJson(
      json,
    ).toEntity();
    expect(resume.serverTimeUtc, checkout.serverTimeUtc);
    expect(resume.holdExpiresAtUtc, DateTime.utc(2026, 10, 21, 12, 15));
  });
  test('checkout and resume support eligibilityCheckedAtUtc when serverTimeUtc is omitted', () {
    final json = <String, dynamic>{
      'subscriptionId': 'subscription',
      'paymentUrl': 'https://example.com/pay',
      'holdExpiresAtUtc': '2026-10-22T02:53:01.366282Z',
      'eligibilityCheckedAtUtc': '2026-10-22T02:38:01.2364085Z',
    };
    final checkout = PaymentCheckoutResponseDto.fromJson(json).toEntity();
    expect(checkout.serverTimeUtc, DateTime.parse('2026-10-22T02:38:01.2364085Z'));
    expect(checkout.holdExpiresAtUtc, json['holdExpiresAtUtc']);
    final resume = SubscriptionBillingResumeResponseDto.fromJson(
      json,
    ).toEntity();
    expect(resume.serverTimeUtc, checkout.serverTimeUtc);
    expect(resume.holdExpiresAtUtc, DateTime.parse('2026-10-22T02:53:01.366282Z'));
  });
  test(
    'hold duration is server anchored and expires using monotonic elapsed time',
    () {
      var elapsed = Duration.zero;
      final clock = PaymentHoldClock(
        expiresAtUtc: DateTime.utc(2026, 10, 21, 12, 15),
        serverTimeUtc: DateTime.utc(2026, 10, 21, 12),
        elapsed: () => elapsed,
      );
      expect(clock.remaining, const Duration(minutes: 15));
      elapsed = const Duration(minutes: 14, seconds: 59);
      expect(clock.remaining, const Duration(seconds: 1));
      expect(clock.isExpired, false);
      elapsed = const Duration(minutes: 15);
      expect(clock.isExpired, true);
      elapsed = const Duration(days: 1);
      expect(clock.remaining, Duration.zero);
    },
  );
  test('renewed server hold restarts the payment window', () {
    final expired = PaymentHoldClock(
      expiresAtUtc: DateTime.utc(2026, 10, 21, 12),
      serverTimeUtc: DateTime.utc(2026, 10, 21, 12, 1),
    );
    expect(expired.isExpired, true);
    final renewed = PaymentHoldClock(
      expiresAtUtc: DateTime.utc(2026, 10, 21, 12, 16),
      serverTimeUtc: DateTime.utc(2026, 10, 21, 12, 1),
      elapsed: () => Duration.zero,
    );
    expect(renewed.remaining, const Duration(minutes: 15));
  });
  test(
    'quote changed uses existing availability recovery for both failure code sources',
    () {
      expect(
        PaymentState(
          checkoutFailure: Failure(
            code: 'checkout.quote_changed',
            errorMessage: '',
          ),
        ).isAvailabilityChangedFailure,
        true,
      );
      expect(
        PaymentState(
          checkoutFailure: Failure(
            errorMessage: '',
            exception: const ApiException(
              message: '',
              errorType: ApiErrorType.conflict,
              backendErrorCode: 'checkout.quote_changed',
            ),
          ),
        ).isAvailabilityChangedFailure,
        true,
      );
    },
  );
}
