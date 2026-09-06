import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/food_preferences/data/mapper/food_preferences_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

void main() {
  group('food preferences request contract', () {
    test(
      'allergies include backend names and no legacy confirmation fields',
      () {
        const allergies = [
          FoodPreferenceItemEntity(
            code: 'MILK',
            nameAr: 'الحليب ومنتجات الألبان',
            nameEn: 'Milk',
          ),
        ];

        expect(allergies.toAllergiesDto().toJson(), {
          'allergies': [
            {
              'code': 'MILK',
              'nameAr': 'الحليب ومنتجات الألبان',
              'nameEn': 'Milk',
            },
          ],
        });
      },
    );

    test('NONE allergy is sent as an empty array', () {
      const allergies = [
        FoodPreferenceItemEntity(
          code: FoodPreferenceItemEntity.noneCode,
          nameAr: 'لا توجد حساسية',
          nameEn: 'No allergies',
        ),
      ];

      expect(allergies.toAllergiesDto().toJson(), {'allergies': <Object>[]});
    });

    test('dietary request contains only selected codes', () {
      const preferences = FoodPreferencesEntity(
        dietaryPreferences: [
          FoodPreferenceItemEntity(
            code: 'KETO',
            nameAr: 'كيتو',
            nameEn: 'Keto',
          ),
        ],
      );

      expect(preferences.toDietaryDto().toJson(), {
        'dietaryPreferenceCodes': ['KETO'],
      });
    });

    test('NONE dietary preference is sent as an empty array', () {
      const preferences = FoodPreferencesEntity(
        dietaryPattern: FoodPreferenceItemEntity.noneCode,
        dietaryPreferences: [
          FoodPreferenceItemEntity(
            code: FoodPreferenceItemEntity.noneCode,
            nameAr: 'لا أتبع نظاماً غذائياً معيناً',
            nameEn: 'No specific diet',
          ),
        ],
      );

      expect(preferences.toDietaryDto().toJson(), {
        'dietaryPreferenceCodes': <String>[],
      });
    });
  });
}
