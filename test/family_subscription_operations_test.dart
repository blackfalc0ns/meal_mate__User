import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/request/family_delivery_address_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/response/family_delivery_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/mapper/family_delivery_address_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/family_management_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';

void main() {
  group('Task 7: Subscription Operations & Delivery Address Contract Tests', () {
    test(
      '1. Separates current and upcoming subscriptions, preserving current service through inclusive end date',
      () {
        final dto = FamilyMemberDetailResponseDto(
          memberId: 'm-100',
          displayName: 'Ahmad',
          role: 'member',
          memberSubscriptionId: 'sub-current-1',
          currentSubscriptionId: 'sub-current-1',
          upcomingSubscriptionId: 'sub-upcoming-2',
          startDate: '2026-10-01',
          endDate: '2026-10-15',
          canRenew: true,
          renewalPath: '/api/v1/renewals/req-123',
        );

        final entity = dto.toEntity('en');

        expect(entity.currentSubscriptionId, equals('sub-current-1'));
        expect(entity.upcomingSubscriptionId, equals('sub-upcoming-2'));
        expect(entity.hasUpcomingSubscription, isTrue);

        // Current subscription is active on October 15 (inclusive end date)
        expect(
          entity.isServiceActive(atDate: DateTime(2026, 10, 15, 14, 0)),
          isTrue,
        );
        expect(
          entity.isServiceActive(atDate: DateTime(2026, 10, 15, 23, 59)),
          isTrue,
        );

        // Current subscription expires after inclusive end date
        expect(
          entity.isServiceActive(atDate: DateTime(2026, 10, 16, 0, 1)),
          isFalse,
        );

        // Upcoming subscription does NOT replace current before its start date
        final upcomingStartDate = DateTime(2026, 10, 16);
        expect(
          entity.isUpcomingActive(
            atDate: DateTime(2026, 10, 15),
            upcomingStartDate: upcomingStartDate,
          ),
          isFalse,
        );

        // Upcoming subscription becomes active once its start date arrives
        expect(
          entity.isUpcomingActive(
            atDate: DateTime(2026, 10, 16, 10, 0),
            upcomingStartDate: upcomingStartDate,
          ),
          isTrue,
        );
      },
    );

    test(
      '2. Renewal checkout request adheres to contract with stable idempotency, contract version, and defaults',
      () {
        const request = FamilyRenewalCheckoutRequestDto(
          startDate: '2026-10-16',
          addressId: 'addr-uuid-99',
          callbackUrl: 'app://callback',
          errorUrl: 'app://error',
          correlationId: 'corr-01',
          idempotencyKey: 'idemp-stable-key',
        );

        final json = request.toJson();

        expect(json['startDate'], equals('2026-10-16'));
        expect(json['addressId'], equals('addr-uuid-99'));
        expect(json['callbackUrl'], equals('app://callback'));
        expect(json['errorUrl'], equals('app://error'));
        expect(json['correlationId'], equals('corr-01'));
        expect(json['paymentMethodId'], equals(3));
        expect(json['clientContractVersion'], equals(1));
        expect(json['idempotencyKey'], equals('idemp-stable-key'));
      },
    );

    test(
      '3. Cancellation quote and result carry server net settlement without promising unverified refund',
      () {
        const quoteDto = SubscriptionBillingCancellationQuoteResponseDto(
          subscriptionId: 'sub-001',
          totalServiceDays: 30,
          deliveredDays: 10,
          lockedKitchenDays: 2,
          refundableDays: 18,
          dailyBoxPrice: 50.0,
          refundAmount: 900.0,
          currencyCode: 'SAR',
          effectiveCancellationDate: '2026-10-20',
          policyMessageAr: 'سياسة الاسترجاع',
          cancellationFeeAmount: 50.0,
          netRefundAmount: 850.0,
          refundToCashWallet: true,
          payerCustomerUserId: 'payer-user-77',
          batchId: 'batch-999',
        );

        final quoteEntity = quoteDto.toEntity();

        expect(quoteEntity.cancellationFeeAmount, equals(50.0));
        expect(quoteEntity.netRefundAmount, equals(850.0));
        expect(quoteEntity.refundToCashWallet, isTrue);
        expect(quoteEntity.payerCustomerUserId, equals('payer-user-77'));
        expect(quoteEntity.batchId, equals('batch-999'));

        const resultDto = SubscriptionBillingCancellationResultResponseDto(
          requestId: 'req-cancel-1',
          subscriptionId: 'sub-001',
          status: 'Completed',
          statusNameAr: 'مكتمل',
          totalServiceDays: 30,
          deliveredDays: 10,
          lockedKitchenDays: 2,
          refundableDays: 18,
          dailyBoxPrice: 50.0,
          refundAmount: 900.0,
          currencyCode: 'SAR',
          effectiveCancellationDate: '2026-10-20',
          messageAr: 'تمت التسوية',
          timestampUtc: '2026-10-12T10:00:00Z',
          cancellationFeeAmount: 50.0,
          netRefundAmount: 850.0,
          refundedToWallet: true,
          payerCustomerUserId: 'payer-user-77',
          settlementId: 'settle-88',
        );

        final resultEntity = resultDto.toEntity();

        expect(resultEntity.netRefundAmount, equals(850.0));
        expect(resultEntity.refundedToWallet, isTrue);
        expect(resultEntity.settlementId, equals('settle-88'));
      },
    );

    test(
      '4. Delivery address amendment passes expectedVersion and respects skipped protected days',
      () {
        const requestDto = FamilyDeliveryAddressRequestDto(
          addressId: 'addr-new-1',
          effectiveFromDate: '2026-10-18',
          expectedVersion: 4,
        );

        final json = requestDto.toJson();
        expect(json['addressId'], equals('addr-new-1'));
        expect(json['effectiveFromDate'], equals('2026-10-18'));
        expect(json['expectedVersion'], equals(4));

        const resultDto = FamilyDeliveryAddressResultResponseDto(
          subscriptionId: 'sub-001',
          version: 5,
          amendmentId: 'amend-001',
          effectiveFromDate: '2026-10-18',
          affectedDayIds: ['day-10-18', 'day-10-19', 'day-10-20'],
          skippedDayIds: [
            'day-10-16',
            'day-10-17',
          ], // protected days skipped by server
        );

        final resultEntity = resultDto.toEntity();

        expect(resultEntity.version, equals(5));
        expect(resultEntity.isDayAffected('day-10-18'), isTrue);
        expect(resultEntity.isDaySkipped('day-10-16'), isTrue);
        expect(resultEntity.isDaySkipped('day-10-17'), isTrue);
        expect(resultEntity.isDayAffected('day-10-16'), isFalse);
      },
    );
  });
}
