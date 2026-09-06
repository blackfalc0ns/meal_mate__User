import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_summary_response_dto.dart';

void main() {
  test('maps the complete upgrade summary contract', () {
    final response = SubscriptionUpgradeSummaryResponseDto.fromJson({
      'subscriptionId': 'sub-1',
      'currentTier': {
        'tier': 'Basic',
        'tierNameAr': 'أساسي',
        'tierNameEn': 'Basic',
        'accessibleRestaurantCount': 21,
      },
      'targetTier': {
        'tier': 'Platinum',
        'tierNameAr': 'بلاتينيوم',
        'tierNameEn': 'Platinum',
        'accessibleRestaurantCount': 39,
      },
      'currentTierRestaurants': [],
      'targetTierRestaurants': [],
      'newlyAddedRestaurants': [
        {
          'id': 'restaurant-2',
          'nameAr': 'هيلثي ستيشن',
          'nameEn': 'Healthy Station',
          'logoUrl': '/uploads/restaurant-2',
          'rating': 4.9,
          'tier': 'Platinum',
        },
      ],
      'effectiveFromDate': '2026-09-10',
      'effectiveNoticeAr': 'يبدأ التفعيل بعد مهلة 72 ساعة.',
      'effectiveNoticeEn': 'Activation starts after 72 hours.',
      'restaurantRepetition': {
        'limit': 3,
        'restaurantCount': 39,
        'durationDays': 12,
      },
      'currentRemainingCredit': 70.5,
      'targetRemainingPrice': 86.5,
      'priceDifference': 16.0,
      'currencyCode': 'KWD',
      'remainingServiceDays': 12,
      'totalServiceDays': 26,
      'paymentMethods': [
        {
          'paymentMethodId': 1,
          'code': 'kn',
          'nameAr': 'كي نت',
          'nameEn': 'KNET',
          'integrationType': 'MYFATOORAH_HOSTED',
          'serviceCharge': 0.0,
          'totalAmount': 16.0,
          'currencyCode': 'KWD',
          'isAvailable': true,
          'imageUrl': 'https://example.com/kn.png',
        },
      ],
      'upgradeEndpoint':
          '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
    });

    final entity = RestaurantTierUpgradeMapper.toSummaryEntity(response);

    expect(entity.subscriptionId, 'sub-1');
    expect(entity.currentTier.accessibleRestaurantCount, 21);
    expect(entity.targetTier.accessibleRestaurantCount, 39);
    expect(entity.newlyAddedRestaurants.single.id, 'restaurant-2');
    expect(entity.restaurantRepetition.limit, 3);
    expect(entity.effectiveFromDate, '2026-09-10');
    expect(entity.priceDifference, 16.0);
    expect(entity.paymentMethods.single.id, 1);
    expect(entity.paymentMethods.single.serviceCharge, 0.0);
  });
}
