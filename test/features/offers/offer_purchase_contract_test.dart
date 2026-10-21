import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_state.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_purchase_options_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_purchase_options_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';

void main() {
  test('direct payment requires explicit review consent and a live quote', () {
    final summary = SubscriptionSummaryResponseDto.fromJson({
      'canCheckout': true,
      'quoteId': 'q',
      'finalPrice': 20,
      'termsAcceptanceRequired': false,
    }).toEntity();
    final state = OfferPurchaseState(
      summary: summary,
      selectedOption: const OfferPurchaseOptionEntity(
        programId: 'p',
        bundleId: 'b',
        tier: 'Basic',
        durationDays: 6,
        startDate: '2026-11-01',
        includeFriday: false,
        canCheckout: true,
      ),
      selectedMethod: const PaymentMethodEntity(
        id: 3,
        type: PaymentMethodType.payzah,
        title: '',
        subtitle: '',
        isAvailable: true,
      ),
      quoteExpiresAtLocal: DateTime.now().add(const Duration(minutes: 5)),
    );
    expect(state.canPay, false);
    expect(state.copyWith(termsAccepted: true).canPay, true);
    expect(
      state
          .copyWith(
            termsAccepted: true,
            quoteExpiresAtLocal: DateTime.now().subtract(
              const Duration(seconds: 1),
            ),
          )
          .canPay,
      false,
    );
  });

  test('purchase options preserve server selection and blocked prices', () {
    final response = OfferPurchaseOptionsResponseDto.fromJson({
      'offerId': 'offer-1',
      'subscriptionType': 'Individual',
      'options': [
        {
          'programId': 'program-1',
          'bundleId': 'bundle-1',
          'tier': 'Basic',
          'durationDays': 6,
          'startDate': '2026-10-26',
          'includeFriday': false,
          'canCheckout': true,
          'finalPrice': 77.25,
          'currencyCode': 'KWD',
        },
        {
          'programId': 'program-2',
          'bundleId': 'bundle-2',
          'tier': 'Premium',
          'durationDays': 13,
          'startDate': '2026-10-26',
          'canCheckout': false,
          'blockingReasons': [
            {
              'code': 'checkout.capacity_unavailable',
              'messageEn': 'No capacity',
            },
          ],
        },
      ],
    }).toEntity();

    expect(response.options, hasLength(2));
    expect(response.options.first.finalPrice, 77.25);
    expect(response.options.last.finalPrice, isNull);
    expect(response.options.last.canCheckout, isFalse);
    expect(
      response.options.last.blockingReasons.first.messageEn,
      'No capacity',
    );
  });

  test('offer summary quote and checkout body keep matching IDs', () {
    final summary = SubscriptionSummaryResponseDto.fromJson({
      'quoteId': 'quote-1',
      'canCheckout': true,
      'summaryExpiresAtUtc': '2026-10-19T12:15:00Z',
      'serverNowUtc': '2026-10-19T12:00:00Z',
      'basePrice': 100,
      'campaignDiscount': 20,
      'promoDiscount': 0,
      'walletCredit': 5,
      'gatewayFee': 2.077,
      'finalPrice': 77.25,
      'blockingReasons': [
        {
          'code': 'checkout.address_required',
          'messageAr': 'أضف عنوانًا',
          'messageEn': 'Add an address',
        },
      ],
    });
    expect(summary.quoteId, 'quote-1');
    expect(summary.finalPrice, 77.25);
    expect(summary.blockingReasonDetails?.first.messageEn, 'Add an address');

    final body = PaymentCheckoutRequestDto(
      programId: 'program-1',
      bundleId: 'bundle-1',
      tier: 'Basic',
      durationDays: 6,
      startDate: '2026-10-26',
      includeFriday: false,
      offerId: 'offer-1',
      quoteId: summary.quoteId,
      idempotencyKey: 'stable-key',
      paymentMethodId: 3,
      callbackUrl: 'https://example.test/success',
      errorUrl: 'https://example.test/error',
      correlationId: 'stable-key',
    ).toJson();
    expect(body['offerId'], 'offer-1');
    expect(body['quoteId'], 'quote-1');
    expect(body['idempotencyKey'], 'stable-key');

    final checkout = PaymentCheckoutResponseDto.fromJson({
      'subscriptionId': 'subscription-1',
      'paymentUrl': 'https://example.test/pay',
      'holdExpiresAtUtc': '2026-10-19T12:16:00Z',
      'paymentStatus': 'PendingPayment',
      'fulfillmentStatus': 'PendingPayment',
      'menuPlanVersionId': 'menu-1',
      'paymentDate': '2026-10-26',
    }).toEntity();
    expect(checkout.subscriptionId, 'subscription-1');
    expect(checkout.menuPlanVersionId, 'menu-1');
    expect(checkout.paymentDate, '2026-10-26');
  });
}
