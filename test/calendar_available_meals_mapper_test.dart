import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';

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
}
