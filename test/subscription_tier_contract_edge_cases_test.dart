import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';

void main() {
  group('Task 3: Subscription Tier & Availability Contract Edge Cases', () {
    test(
      'Tier with price but zero restaurants and canSelect=false preserves card reason',
      () {
        const dto = SubscriptionTierResponseDto(
          tier: 'Standard',
          nameAr: 'ستاندرد',
          nameEn: 'Standard',
          totalPrice: 45.0,
          currencyCode: 'KWD',
          restaurantCount: 0,
          restaurants: [],
          canSelect: false,
          isAvailable: false,
          disabledReason: 'no_restaurants_for_selection',
          availability: SubscriptionAvailabilityResponseDto(
            status: 'no_restaurants_for_selection',
            coveredRestaurantCount: 2,
            eligibleRestaurantCount: 0,
            messageCode: 'subscription_flow.no_restaurants_for_selection',
            scope: 'period',
          ),
        );

        final entity = dto.toEntity();

        expect(entity.tier, equals('Standard'));
        expect(entity.totalPrice, equals(45.0));
        expect(entity.restaurantCount, equals(0));
        expect(entity.canSelect, isFalse);
        expect(entity.isAvailable, isFalse);
        expect(entity.disabledReason, equals('no_restaurants_for_selection'));
        expect(entity.availability?.isScopePeriod, isTrue);
        expect(entity.availability?.eligibleRestaurantCount, equals(0));

        final uiModel = entity.toTierUiModel('ar');
        expect(uiModel.canSelect, isFalse);
        expect(uiModel.isAvailable, isFalse);
        expect(uiModel.disabledReason, equals('no_restaurants_for_selection'));
      },
    );

    test('Friday unavailable sets fridayAvailability correctly', () {
      const dto = SubscriptionTierResponseDto(
        tier: 'Plus',
        nameAr: 'بلس',
        nameEn: 'Plus',
        includeFriday: true,
        fridayAvailability: SubscriptionFridayAvailabilityResponseDto(
          isAvailable: false,
          restaurantCount: 0,
          code: 'friday_unavailable',
          messageAr: 'خدمة يوم الجمعة غير متاحة',
          messageEn: 'Friday delivery is unavailable',
          displayType: 'warning',
        ),
      );

      expect(dto.fridayAvailability?.isAvailable, isFalse);
      expect(dto.fridayAvailability?.code, equals('friday_unavailable'));
    });

    test(
      'Period with one uncovered day has period_unavailable status and scope=period',
      () {
        const dto = SubscriptionTierResponseDto(
          tier: 'Max',
          nameAr: 'ماكس',
          nameEn: 'Max',
          totalPrice: 60.0,
          canSelect: false,
          isAvailable: false,
          disabledReason: 'period_unavailable',
          availability: SubscriptionAvailabilityResponseDto(
            status: 'period_unavailable',
            coveredRestaurantCount: 5,
            eligibleRestaurantCount: 0,
            messageCode: 'subscription_flow.period_unavailable',
            scope: 'period',
          ),
        );

        final entity = dto.toEntity();
        expect(entity.canSelect, isFalse);
        expect(entity.isAvailable, isFalse);
        expect(entity.availability?.scope, equals('period'));
        expect(entity.availability?.isScopePeriod, isTrue);
        expect(entity.availability?.status, equals('period_unavailable'));
      },
    );
  });
}
