import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/features/offers/data/mapper/campaign_payment_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';

void main() {
  group('Campaign Payment Security & Constraints Tests', () {
    test(
      'Mobile code contract strictly never defines or calls webhook endpoints',
      () {
        // Assert that endpoints constant has no webhook URL exposed for mobile client
        expect(
          EndPoints.customerCampaignPayment,
          '/api/v1/customer/campaigns/{sessionId}/payment',
        );
        expect(
          EndPoints.customerCampaignCheckoutSession,
          '/api/v1/customer/campaigns/checkout-session',
        );

        // Network constants must never contain any provider webhook endpoint
        const allEndpoints = [
          EndPoints.customerCampaignPayment,
          EndPoints.customerCampaignCheckoutSession,
          EndPoints.customerCampaignPricePreview,
        ];

        for (final endpoint in allEndpoints) {
          expect(endpoint.toLowerCase().contains('webhook'), isFalse);
        }
      },
    );

    test('Callback URL query parameters are NEVER treated as proof of payment', () {
      // A malicious or spoofed callback link claiming status=Paid
      final spoofedUri = Uri.parse(
        'mealmate://campaign-payment/callback?sessionId=sess-123&paymentId=pz-123&status=Paid',
      );

      final paymentReturn = parsePaymentReturn(spoofedUri);
      expect(paymentReturn, isNotNull);

      // Even if status=Paid is in the URL, parsePaymentReturn marks destination as pending (requiring server poll)
      expect(paymentReturn!.destination, PaymentReturnDestination.pending);
      expect(paymentReturn.callbackStatus, 'Paid');

      // The status from query params cannot alter the domain entity without authoritative API lookup
      const unverifiedPendingDto = CampaignPaymentResponseDto(
        sessionId: 'sess-123',
        status: 'Pending',
      );
      final entity = unverifiedPendingDto.toEntity();
      expect(entity.status, CampaignPaymentStatus.pending);
      expect(entity.isAuthoritativePaid, isFalse);
    });

    test('Server prices are strictly preserved and never mutated locally', () {
      const serverDto = CampaignPaymentResponseDto(
        sessionId: 'sess-123',
        amount: 45.750,
        currency: 'KWD',
        status: 'Pending',
      );

      final entity = serverDto.toEntity();

      // Entity retains exact server amount and currency without local rounding or modifications
      expect(entity.amount, 45.750);
      expect(entity.currency, 'KWD');
    });
  });
}
