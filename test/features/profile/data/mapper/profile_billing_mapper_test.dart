import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/profile/data/mapper/profile_billing_mapper.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';

void main() {
  test('maps current subscription backend additions into billing entity', () {
    final dto = ProfileBillingCurrentResponseDto.fromJson({
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
  });

  test('maps freeze policy earliest allowed date into billing entity', () {
    final dto = ProfileBillingFreezePolicyResponseDto.fromJson({
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
