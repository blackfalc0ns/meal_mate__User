import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/mapper/campaign_payment_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

void main() {
  group('CampaignPaymentMapper Tests', () {
    test('StartCampaignPaymentRequestEntity maps to DTO accurately', () {
      const entity = StartCampaignPaymentRequestEntity(
        sessionId: 'sess-123',
        idempotencyKey: 'idemp-456',
        callbackUrl: 'mealmate://campaign-payment/callback',
        errorUrl: 'mealmate://campaign-payment/error',
        paymentMethodId: 3,
      );

      final dto = entity.toDto();

      expect(dto.idempotencyKey, 'idemp-456');
      expect(dto.callbackUrl, 'mealmate://campaign-payment/callback');
      expect(dto.errorUrl, 'mealmate://campaign-payment/error');
      expect(dto.paymentMethodId, 3);
    });

    test('CampaignPaymentResponseDto toEntity with full values', () {
      const dto = CampaignPaymentResponseDto(
        sessionId: 'sess-123',
        paymentId: 'pz-abc',
        paymentUrl: 'https://pay.test/pz-abc',
        amount: 15.750,
        currency: 'KWD',
        status: 'Pending',
        expiresAtUtc: '2026-10-15T10:00:00.000Z',
      );

      final entity = dto.toEntity();

      expect(entity.sessionId, 'sess-123');
      expect(entity.paymentId, 'pz-abc');
      expect(entity.paymentUrl, 'https://pay.test/pz-abc');
      expect(entity.amount, 15.750);
      expect(entity.currency, 'KWD');
      expect(entity.status, CampaignPaymentStatus.pending);
      expect(entity.rawStatus, 'Pending');
      expect(entity.expiresAtUtc, DateTime.parse('2026-10-15T10:00:00.000Z'));
      expect(entity.isTerminal, false);
      expect(entity.isAuthoritativePaid, false);
    });

    test(
      'CampaignPaymentResponseDto status mappings: Paid, Failed, Expired, Cancelled, Unknown',
      () {
        // Paid via status string
        expect(
          const CampaignPaymentResponseDto(status: 'Paid').toEntity().status,
          CampaignPaymentStatus.paid,
        );
        // Paid via isPaid flag
        expect(
          const CampaignPaymentResponseDto(
            status: 'Pending',
            isPaid: true,
          ).toEntity().status,
          CampaignPaymentStatus.paid,
        );
        // Failed via status
        expect(
          const CampaignPaymentResponseDto(status: 'Failed').toEntity().status,
          CampaignPaymentStatus.failed,
        );
        // Failed via isFailed
        expect(
          const CampaignPaymentResponseDto(isFailed: true).toEntity().status,
          CampaignPaymentStatus.failed,
        );
        // Expired
        expect(
          const CampaignPaymentResponseDto(status: 'Expired').toEntity().status,
          CampaignPaymentStatus.expired,
        );
        // Cancelled
        expect(
          const CampaignPaymentResponseDto(
            status: 'Cancelled',
          ).toEntity().status,
          CampaignPaymentStatus.cancelled,
        );
        // Canceled (US spelling)
        expect(
          const CampaignPaymentResponseDto(
            status: 'Canceled',
          ).toEntity().status,
          CampaignPaymentStatus.cancelled,
        );
        // Unknown preserved in rawStatus
        final unknownEntity = const CampaignPaymentResponseDto(
          status: 'UnderReview',
        ).toEntity();
        expect(unknownEntity.status, CampaignPaymentStatus.unknown);
        expect(unknownEntity.rawStatus, 'UnderReview');
      },
    );

    test('CampaignPaymentResponseDto handles all nulls safely', () {
      const dto = CampaignPaymentResponseDto();
      final entity = dto.toEntity();

      expect(entity.sessionId, '');
      expect(entity.status, CampaignPaymentStatus.pending);
      expect(entity.currency, 'KWD');
      expect(entity.paymentId, isNull);
      expect(entity.paymentUrl, isNull);
      expect(entity.amount, isNull);
      expect(entity.expiresAtUtc, isNull);
      expect(entity.subscriptionId, isNull);
    });
  });
}
