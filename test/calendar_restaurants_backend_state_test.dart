import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';

void main() {
  test('keeps restaurant availability from the API instead of local usage', () {
    final state = CalendarState(
      days: [
        CalendarDayEntity(
          restaurantId: 'restaurant-1',
          dayNumber: 1,
          weekday: 'Mon',
          date: DateTime(2026, 9),
        ),
        CalendarDayEntity(
          restaurantId: 'restaurant-1',
          dayNumber: 2,
          weekday: 'Tue',
          date: DateTime(2026, 9, 2),
        ),
        CalendarDayEntity(
          restaurantId: 'restaurant-1',
          dayNumber: 3,
          weekday: 'Wed',
          date: DateTime(2026, 9, 3),
        ),
      ],
      restaurants: const [
        CalendarRestaurantOptionEntity(
          id: 'restaurant-1',
          name: 'Fit Plate',
          description: '',
          mealCount: 8,
          rating: '',
          logoType: CalendarRestaurantLogoType.healthyBowl,
          isEnabled: true,
        ),
      ],
    );

    final restaurants = state.restaurantsWithUsageLimits();

    expect(restaurants.single.isEnabled, isTrue);
    expect(restaurants.single.isUsageLimitReached, isFalse);
  });

  test('maps restaurant availability fields from the API response', () {
    final response = CalendarRestaurantResponseDto.fromJson({
      'restaurantId': 'restaurant-1',
      'name': 'Fit Plate',
      'limit': 3,
      'usedCount': 1,
      'remainingCount': 2,
      'isBusy': false,
      'isQuotaExhausted': false,
      'isEnabled': false,
      'disabledReason': 'quota_exhausted',
      'safeMealCount': 8,
    });

    final entity = response.toOptionEntity('en');

    expect(entity.maxUsageCount, 3);
    expect(entity.usedCount, 1);
    expect(entity.remainingCount, 2);
    expect(entity.isBusy, isFalse);
    expect(entity.isQuotaExhausted, isFalse);
    expect(entity.isEnabled, isFalse);
    expect(entity.disabledReason, 'quota_exhausted');
  });

  test(
    'maps restaurant rating delivery and tier fields from the API response',
    () {
      final response = CalendarRestaurantResponseDto.fromJson({
        'restaurantId': 'restaurant-1',
        'name': 'Fit Plate',
        'safeMealCount': 8,
        'rating': 4.8,
        'ratingCount': 94,
        'deliveryWindowStart': '18:00:00',
        'deliveryWindowEnd': '19:00:00',
        'deliveryTimeText': '6:00 PM - 7:00 PM',
        'tier': 'Platinum',
        'tierName': 'Platinum',
        'tierLogoUrl': 'https://example.com/tier.png',
      });

      final entity = response.toOptionEntity('en');

      expect(entity.rating, '4.8');
      expect(entity.ratingCount, 94);
      expect(entity.deliveryWindow, '6:00 PM - 7:00 PM');
      expect(entity.tierName, 'Platinum');
      expect(entity.tierLogoUrl, 'https://example.com/tier.png');
    },
  );

  test('defaults rating to 4.5 when rating is null in API response', () {
    final response = CalendarRestaurantResponseDto.fromJson({
      'restaurantId': 'f757b93d-2909-4fc5-8480-0a5f4e071080',
      'nameAr': 'مطبخ دايت كير',
      'rating': null,
      'ratingCount': 0,
    });

    final optionEntity = response.toOptionEntity('ar');
    final restaurantEntity = response.toRestaurantEntity('ar');

    expect(optionEntity.rating, '4.5');
    expect(restaurantEntity.rating, '4.5');
  });
}
