import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';

void main() {
  test(
    'family disliked ingredients use the existing ingredientCodes shape',
    () {
      expect(
        const FoodPreferencesDislikedIngredientsRequestDto(
          ingredientCodes: ['INGREDIENT:avocado'],
        ).toJson(),
        {
          'ingredientCodes': ['INGREDIENT:avocado'],
        },
      );
    },
  );

  test('NONE is sent as a real family allergy selection', () {
    expect(
      const FamilyMemberAllergiesRequestDto(
        allergies: [FamilyMemberAllergyRequestDto(code: 'NONE')],
      ).toJson(),
      {
        'selectedCodes': ['NONE'],
      },
    );
  });

  test('allergen severity is included when selected', () {
    expect(
      const FamilyMemberAllergiesRequestDto(
        allergies: [
          FamilyMemberAllergyRequestDto(code: 'MILK', severity: 'High'),
        ],
      ).toJson(),
      {
        'selectedCodes': ['MILK'],
      },
    );
  });

  test('dietary request uses only dietaryPreferenceCodes', () {
    expect(
      const FoodPreferencesDietaryRequestDto(
        dietaryPreferenceCodes: ['NONE'],
      ).toJson(),
      {
        'dietaryPreferenceCodes': ['NONE'],
      },
    );
  });
}
