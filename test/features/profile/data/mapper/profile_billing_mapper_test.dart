import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';

void main() {
  test('maps current subscription backend additions into billing entity', () {
    final dto = SubscriptionBillingCurrentResponseDto.fromJson({
      'subscription': {
        'subscriptionId': 'sub-1',
        'status': 'Scheduled',
        'statusNameAr': 'مجدول',
        'programId': 'program-1',
        'programNameAr': 'برنامج الكيتو',
        'programNameEn': 'Keto Program',
        'bundleId': 'bundle-1',
        'bundleNameAr': 'باقة كيتو',
        'bundleNameEn': 'Keto Bundle',
        'tier': 'Basic',
        'tierNameAr': 'أساسي',
        'tierNameEn': 'Basic',
        'mealsPerDay': 2,
        'startDate': '2026-09-06',
        'endDate': '2026-09-17',
        'nextRenewalDate': '2026-09-18',
        'totalServiceDays': 12,
        'completedServiceDays': 1,
        'remainingServiceDays': 11,
        'progressPercentage': 8.3,
        'paidAmount': 70.5,
        'currencyCode': 'KWD',
        'pendingFreeze': {
          'requestId': 'freeze-1',
          'startDate': '2026-09-10',
          'endDate': '2026-09-16',
          'freezeDays': 7,
          'status': 'Approved',
        },
        'pendingUpgrade': {
          'requestId': 'upgrade-1',
          'fromTier': 'Basic',
          'toTier': 'Elite',
          'priceDifference': 31.75,
          'status': 'Submitted',
        },
        'restaurant': {
          'restaurantId': 'restaurant-1',
          'nameAr': 'دايت سنتر',
          'nameEn': 'Diet Center',
          'logoUrl': '/uploads/restaurants/diet-center.png',
        },
        'actions': {
          'canRenew': true,
          'canFreeze': true,
          'canCancel': true,
          'canUpgrade': false,
          'upgradeUnavailableReason': 'upgrade_request_pending',
          'freezeStartDelayDays': 3,
          'maximumFreezeDays': 7,
          'freezeExtendsSubscriptionEnd': true,
          'earliestFreezeStartDate': '2026-09-06',
          'renewalEndpoint': '/renew',
          'freezeEndpoint': '/freeze',
          'cancellationEndpoint': '/cancel',
          'upgradeEndpoint': '/upgrade',
          'cancellationQuoteEndpoint': '/cancel-quote',
          'freezeDetailsEndpoint':
              '/api/v1/customer/subscriptions/sub-1/freeze-details',
        },
        'activeFreeze': {
          'requestId': 'freeze-details-1',
          'startDate': '2026-09-07',
          'endDate': '2026-09-12',
          'freezeDays': 6,
          'frozenServiceDaysCount': 5,
          'status': 'Approved',
          'statusNameAr': 'approved ar',
          'isCurrentlyActive': false,
          'isUpcoming': true,
          'reason': 'travel',
          'createdAtUtc': '2026-09-03T14:18:47.743613Z',
          'processedAtUtc': '2026-09-03T14:18:47.743302Z',
          'frozenServiceDates': [
            '2026-09-07',
            '2026-09-08',
            '2026-09-09',
            '2026-09-10',
            '2026-09-12',
          ],
          'compensationDates': [
            '2026-09-20',
            '2026-09-21',
            '2026-09-22',
            '2026-09-23',
            '2026-09-24',
          ],
          'subscriptionEndDate': '2026-09-24',
          'summaryAr': 'summary ar',
          'summaryEn': 'summary en',
        },
      },
      'emptyStateCode': null,
    });

    final entity = dto.toEntity().subscription!;

    expect(entity.programId, 'program-1');
    expect(entity.bundleId, 'bundle-1');
    expect(entity.mealsPerDay, 2);
    expect(entity.startDate, '2026-09-06');
    expect(entity.endDate, '2026-09-17');
    expect(entity.pendingFreeze?.freezeDays, 7);
    expect(entity.pendingUpgrade?.toTier, 'Elite');
    expect(entity.actions.renewalEndpoint, '/renew');
    expect(entity.actions.freezeEndpoint, '/freeze');
    expect(entity.actions.earliestFreezeStartDate, '2026-09-06');
    expect(entity.actions.cancellationEndpoint, '/cancel');
    expect(entity.actions.cancellationQuoteEndpoint, '/cancel-quote');
    expect(
      entity.actions.freezeDetailsEndpoint,
      '/api/v1/customer/subscriptions/sub-1/freeze-details',
    );
    expect(entity.activeFreeze?.requestId, 'freeze-details-1');
    expect(entity.activeFreeze?.statusNameAr, 'approved ar');
    expect(entity.activeFreeze?.frozenServiceDaysCount, 5);
    expect(entity.activeFreeze?.compensationDates, [
      '2026-09-20',
      '2026-09-21',
      '2026-09-22',
      '2026-09-23',
      '2026-09-24',
    ]);
    expect(entity.activeFreeze?.subscriptionEndDate, '2026-09-24');
    expect(entity.activeFreeze?.summaryAr, 'summary ar');
  });

  test('maps freeze policy earliest allowed date into billing entity', () {
    final dto = SubscriptionBillingFreezePolicyResponseDto.fromJson({
      'defaultDurationDays': 7,
      'startDelayDays': 3,
      'extendSubscriptionEnd': true,
      'earliestAllowedStartDate': '2026-09-06',
      'messageAr': 'message ar',
      'messageEn': 'message en',
    });

    final entity = dto.toEntity();

    expect(entity.earliestAllowedStartDate, '2026-09-06');
  });
}
