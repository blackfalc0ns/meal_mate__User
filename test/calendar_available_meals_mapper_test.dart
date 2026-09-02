import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

void main() {
  test(
    'maps available meals core ingredient origins from the API response',
    () {
      final response = CalendarAvailableMealsResponseDto.fromJson({
        'restaurantId': 'restaurant-1',
        'nameAr': 'مطعم صحي',
        'logoUrl': 'https://example.com/logo.png',
        'slotRequirements': [
          {
            'slot': 'lunch',
            'slotNameAr': 'الغداء',
            'slotName': 'Lunch',
            'count': 1,
          },
        ],
        'coreIngredients': [
          {
            'id': 'ingredient-1',
            'nameAr': 'أفوكادو',
            'iconUrl': 'https://example.com/avocado.webp',
            'isLocal': true,
            'originCountryCode': 'KW',
            'originCountryNameAr': 'الكويت',
            'flagEmoji': '🇰🇼',
            'name': 'Avocado',
            'originCountryName': 'Kuwait',
          },
        ],
        'meals': const [],
        'selectedMealIds': const [],
      });

      final entity = response.toEntity('ar');

      expect(entity.coreIngredients, hasLength(1));
      expect(entity.coreIngredients.first.id, 'ingredient-1');
      expect(entity.coreIngredients.first.name, 'أفوكادو');
      expect(
        entity.coreIngredients.first.iconUrl,
        'https://example.com/avocado.webp',
      );
      expect(entity.coreIngredients.first.isLocal, isTrue);
      expect(entity.coreIngredients.first.originCountryCode, 'KW');
      expect(entity.coreIngredients.first.originCountryName, 'الكويت');
      expect(entity.coreIngredients.first.flagEmoji, '🇰🇼');
    },
  );

  test('maps localized slot labels supplied by the API response', () {
    final response = CalendarAvailableMealsResponseDto.fromJson({
      'slots': [
        {
          'slot': 'lunch',
          'slotName': 'الغداء',
          'slotNameAr': 'الغداء',
          'count': 1,
          'meals': const [],
        },
      ],
      'selectedMealIds': const [],
    });

    final entity = response.toEntity('en');

    expect(entity.slotRequirements.single.displayName, 'الغداء');
    expect(entity.slots.single.displayName, 'الغداء');
  });

  test('maps selected day response fields used by the calendar UI', () async {
    await initializeDateFormatting('en');

    final response = CalendarDayResponseDto.fromJson({
      'id': 'day-1',
      'serviceDate': '2026-09-05',
      'restaurantId': 'restaurant-1',
      'restaurantNameAr': 'مطعم دايت كير',
      'restaurantLogoUrl': 'https://example.com/logo.png',
      'status': 'SentToRestaurant',
      'uiStatus': 'locked',
      'canEdit': false,
      'lockRemainingSeconds': 0,
      'filledCount': 2,
      'requiredCount': 2,
      'nutritionTotals': {
        'calories': 830.0,
        'proteinG': 52.0,
        'carbsG': 8.0,
        'fatG': 66.0,
      },
      'selectedMeals': [
        {
          'mealId': 'meal-1',
          'nameAr': 'دجاج مشوي مع أرز',
          'slot': 'lunch',
          'slotNameAr': 'الغداء',
          'sortOrder': 1,
          'imageUrl': 'https://example.com/lunch.jpg',
          'calories': 620.0,
          'proteinG': 38.0,
          'carbsG': 5.0,
          'fatG': 50.0,
          'descriptionAr': 'وجبة طازجة',
          'isSelected': true,
        },
        {
          'mealId': 'meal-2',
          'nameAr': 'زبادي يوناني بالشوفان',
          'slot': 'snack',
          'slotNameAr': 'سناك',
          'sortOrder': 2,
          'imageUrl': 'https://example.com/snack.jpg',
          'calories': 210.0,
          'proteinG': 14.0,
          'carbsG': 3.0,
          'fatG': 16.0,
          'descriptionAr': 'وجبة خفيفة',
          'isSelected': true,
        },
      ],
      'deliveryTimeText': '8:00 ص - 4:00 م',
      'tier': 'Basic',
      'tierNameAr': 'أساسي',
      'tierName': 'أساسي',
      'tierLogoUrl':
          'https://ik.imagekit.io/f7h9cj23x/uploads/admin/tiers/Group_19497_apsDC4VCMe.png',
      'programNameAr': 'برنامج الكيتو المتكامل',
      'programName': 'برنامج الكيتو المتكامل',
    });

    final entity = response.toEntity('en');

    expect(entity.id, 'day-1');
    expect(entity.restaurant?.name, 'مطعم دايت كير');
    expect(entity.restaurant?.category, 'برنامج الكيتو المتكامل');
    expect(entity.restaurant?.deliveryDuration, 'أساسي');
    expect(
      entity.restaurant?.tierLogoUrl,
      'https://ik.imagekit.io/f7h9cj23x/uploads/admin/tiers/Group_19497_apsDC4VCMe.png',
    );
    expect(entity.restaurant?.rating, '4.5');
    expect(entity.restaurant?.logoUrl, 'https://example.com/logo.png');
    expect(entity.restaurant?.deliveryWindow, '8:00 ص - 4:00 م');
    expect(entity.isEditable, isFalse);
    expect(entity.isRestaurantClosed, isTrue);
    expect(entity.selectedMealIds, ['meal-1', 'meal-2']);
    expect(entity.meals.map((meal) => meal.title), [
      'دجاج مشوي مع أرز',
      'زبادي يوناني بالشوفان',
    ]);
    expect(entity.nutritionTotals.calories, 830);
    expect(entity.nutritionTotals.proteinG, 52);
    expect(entity.nutritionTotals.carbsG, 8);
    expect(entity.nutritionTotals.fatG, 66);
  });

  test('uses uiStatus when API status is empty', () async {
    await initializeDateFormatting('en');

    final response = CalendarDayResponseDto.fromJson({
      'id': 'day-locked',
      'serviceDate': '2026-09-05',
      'status': '',
      'uiStatus': 'locked',
      'canEdit': true,
    });

    final entity = response.toEntity('en');

    expect(entity.status, 'locked');
    expect(entity.isRestaurantClosed, isTrue);
    expect(entity.isEditable, isFalse);
  });

  test(
    'uses day delivery time when nested restaurant has no delivery window',
    () async {
      await initializeDateFormatting('en');

      final response = CalendarDayResponseDto.fromJson({
        'id': 'day-with-restaurant',
        'serviceDate': '2026-09-05',
        'restaurant': {
          'id': 'restaurant-1',
          'name': 'Diet Care Kitchen',
          'logoUrl': 'https://example.com/logo.png',
        },
        'deliveryTimeText': '8:00 AM - 4:00 PM',
        'tierName': 'Basic',
        'programName': 'Keto Program',
      });

      final entity = response.toEntity('en');

      expect(entity.restaurant?.name, 'Diet Care Kitchen');
      expect(entity.restaurant?.category, 'Keto Program');
      expect(entity.restaurant?.deliveryDuration, 'Basic');
      expect(entity.restaurant?.deliveryWindow, '8:00 AM - 4:00 PM');
    },
  );
}
