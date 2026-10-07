import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';

void main() {
  test('maps an uncompleted subscription and its available actions', () {
    final dto = SubscriptionBillingUncompletedSubscriptionResponseDto.fromJson({
      'subscriptionId': 'sub-1',
      'status': 'PendingPayment',
      'statusNameAr': 'بانتظار الدفع',
      'programId': 'program-1',
      'programNameAr': 'برنامج الكيتو',
      'programNameEn': 'Keto Program',
      'bundleId': 'bundle-1',
      'bundleNameAr': 'باقة كيتو',
      'bundleNameEn': 'Keto Bundle',
      'tier': 'Basic',
      'tierNameAr': 'أساسي',
      'tierNameEn': 'Basic',
      'tierLogoUrl': '/tiers/basic.png',
      'mealsPerDay': 2,
      'imageUrl': '/programs/keto.png',
      'startDate': '2026-09-10',
      'endDate': '2026-09-22',
      'durationDays': 12,
      'includeFriday': false,
      'amount': 70.5,
      'currencyCode': 'KWD',
      'deliveryAddress': 'Hawally',
      'createdAtUtc': '2026-09-06T19:30:00Z',
      'isHoldActive': true,
      'holdRemainingSeconds': 620,
      'holdExpiresAtUtc': '2026-09-06T20:00:00Z',
      'actions': {
        'canDelete': true,
        'canResume': true,
        'deleteEndpoint': '/subscriptions/sub-1',
        'resumeEndpoint': '/subscriptions/sub-1/resume',
      },
    });

    final entity = dto.toEntity();

    expect(entity.subscriptionId, 'sub-1');
    expect(entity.amount, 70.5);
    expect(entity.isHoldActive, isTrue);
    expect(entity.holdRemainingSeconds, 620);
    expect(entity.holdExpiresAtUtc, DateTime.utc(2026, 9, 6, 20));
    expect(entity.actions.canDelete, isTrue);
    expect(entity.actions.resumeEndpoint, '/subscriptions/sub-1/resume');
  });

  test('maps a minimal resume preview without optional plan fields', () {
    final dto = SubscriptionBillingResumePreviewResponseDto.fromJson({
      'subscriptionId': 'sub-1',
      'status': 'PendingPayment',
      'statusNameAr': 'بانتظار الدفع',
      'canPayDirectly': false,
      'reason': 'capacity_hold_expired',
      'suggestedStartDate': '2026-09-10',
      'resumeEndpoint': '/subscriptions/sub-1/resume',
    });

    final entity = dto.toEntity();

    expect(entity.subscriptionId, 'sub-1');
    expect(entity.canPayDirectly, isFalse);
    expect(entity.reason, 'capacity_hold_expired');
    expect(entity.programId, isEmpty);
    expect(entity.holdExpiresAtUtc, isNull);
  });

  test('maps resume execution payment response', () {
    final dto = SubscriptionBillingResumeResponseDto.fromJson({
      'subscriptionId': 'sub-1',
      'paymentUrl': 'https://pay.example/invoice',
      'holdExpiresAtUtc': '2026-09-06T20:15:00Z',
      'finalPrice': 70.5,
      'paymentStatus': 'PendingPayment',
    });

    final entity = dto.toEntity();

    expect(entity.paymentUrl, 'https://pay.example/invoice');
    expect(entity.finalPrice, 70.5);
    expect(entity.paymentStatus, 'PendingPayment');
  });
}
