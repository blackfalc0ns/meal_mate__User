import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/models/request/start_campaign_payment_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';

void main() {
  group('StartCampaignPaymentRequestDto Tests', () {
    test('toJson serializes required and optional fields correctly', () {
      const dto = StartCampaignPaymentRequestDto(
        idempotencyKey: 'idemp-12345',
        callbackUrl: 'mealmate://campaign-payment/callback',
        errorUrl: 'mealmate://campaign-payment/error',
        paymentMethodId: 3,
      );

      final json = dto.toJson();

      expect(json['idempotencyKey'], 'idemp-12345');
      expect(json['callbackUrl'], 'mealmate://campaign-payment/callback');
      expect(json['errorUrl'], 'mealmate://campaign-payment/error');
      expect(json['paymentMethodId'], 3);
    });

    test('toJson defaults paymentMethodId to 3 if omitted', () {
      const dto = StartCampaignPaymentRequestDto(
        idempotencyKey: 'idemp-67890',
        callbackUrl: 'mealmate://campaign-payment/callback',
        errorUrl: 'mealmate://campaign-payment/error',
      );

      final json = dto.toJson();

      expect(json['idempotencyKey'], 'idemp-67890');
      expect(json['paymentMethodId'], 3);
    });
  });

  group('CampaignPaymentResponseDto Tests', () {
    test('fromJson deserializes full start-payment response correctly', () {
      final json = {
        'sessionId': 'session-abc-123',
        'paymentId': 'pz-98765',
        'paymentUrl': 'https://pay.example.com/checkout/pz-98765',
        'amount': 12.500,
        'currency': 'KWD',
        'status': 'Pending',
        'expiresAtUtc': '2026-10-15T12:00:00Z',
      };

      final dto = CampaignPaymentResponseDto.fromJson(json);

      expect(dto.sessionId, 'session-abc-123');
      expect(dto.paymentId, 'pz-98765');
      expect(dto.paymentUrl, 'https://pay.example.com/checkout/pz-98765');
      expect(dto.amount, 12.500);
      expect(dto.currency, 'KWD');
      expect(dto.status, 'Pending');
      expect(dto.expiresAtUtc, '2026-10-15T12:00:00Z');
      expect(dto.isPaid, isNull);
      expect(dto.isFailed, isNull);
      expect(dto.subscriptionId, isNull);
    });

    test(
      'fromJson deserializes full status response correctly (Paid terminal)',
      () {
        final json = {
          'sessionId': 'session-abc-123',
          'paymentId': 'pz-98765',
          'status': 'Paid',
          'isPaid': true,
          'isFailed': false,
          'amount': 12.500,
          'currency': 'KWD',
          'expiresAtUtc': '2026-10-15T12:00:00Z',
          'subscriptionId': 'sub-uuid-456',
        };

        final dto = CampaignPaymentResponseDto.fromJson(json);

        expect(dto.sessionId, 'session-abc-123');
        expect(dto.paymentId, 'pz-98765');
        expect(dto.status, 'Paid');
        expect(dto.isPaid, true);
        expect(dto.isFailed, false);
        expect(dto.amount, 12.500);
        expect(dto.currency, 'KWD');
        expect(dto.expiresAtUtc, '2026-10-15T12:00:00Z');
        expect(dto.subscriptionId, 'sub-uuid-456');
      },
    );

    test(
      'fromJson handles empty / null / partial missing fields defensibly',
      () {
        final json = <String, dynamic>{};

        final dto = CampaignPaymentResponseDto.fromJson(json);

        expect(dto.sessionId, isNull);
        expect(dto.paymentId, isNull);
        expect(dto.paymentUrl, isNull);
        expect(dto.amount, isNull);
        expect(dto.currency, isNull);
        expect(dto.status, isNull);
        expect(dto.expiresAtUtc, isNull);
        expect(dto.isPaid, isNull);
        expect(dto.isFailed, isNull);
        expect(dto.subscriptionId, isNull);
      },
    );

    test(
      'fromJson handles int amount converted to double or numeric variations',
      () {
        final json = {'amount': 12, 'status': 'Failed', 'isFailed': true};

        final dto = CampaignPaymentResponseDto.fromJson(json);

        expect(dto.amount, 12.0);
        expect(dto.status, 'Failed');
        expect(dto.isFailed, true);
      },
    );
  });
}
