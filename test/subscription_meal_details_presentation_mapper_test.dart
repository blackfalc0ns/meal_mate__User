import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_ar.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_en.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/subscription_meal_details_presentation_mapper.dart';

void main() {
  test('maps subscription meal API data to display-ready English details', () {
    final locale = AppLocalizationsEn();
    final result = SubscriptionMealDetailsPresentationMapper.map(
      meal: _meal,
      locale: locale,
      restaurantInitials: 'GK',
      fallbackRating: '4.0',
    );

    expect(result.title, 'Chicken bowl');
    expect(result.description, 'Grilled chicken and rice');
    expect(result.restaurantName, 'Green Kitchen');
    expect(result.restaurantLogo, 'GK');
    expect(result.ratingTitle, locale.meal_details_restaurant_rating);
    expect(result.programLabel, locale.meal_details_meal_type);
    expect(result.deliveryLabel, locale.meal_details_delivery_time);
    expect(result.nutritionTitle, locale.meal_details_nutrition_facts);
    expect(
      result.macroDistributionTitle,
      locale.meal_details_macro_distribution,
    );
    expect(result.allergensTitle, locale.meal_details_allergens);
    expect(result.ratingValue, '4.5 (12)');
    expect(result.programValue, 'Lunch');
    expect(result.deliveryValue, '12:00 - 13:00');
    expect(result.ingredients.single.label, 'Chicken');
    expect(result.ingredients.single.asset, AssetsFake.ingredientChicken);
    expect(result.nutritionItems.map((item) => item.value), [
      '3.5g',
      '40g',
      '35.5g',
      '10g',
      '420',
    ]);
    expect(result.macroItems.map((item) => item.percent), [
      '20%',
      '40%',
      '40%',
    ]);
    expect(result.allergens.single.type, MealDetailsAllergenType.gluten);
  });

  test(
    'uses fallback rating and restaurant initials when API values are absent',
    () {
      final result = SubscriptionMealDetailsPresentationMapper.map(
        meal: _mealWithoutRating,
        locale: AppLocalizationsEn(),
        fallbackRating: '4.8',
      );

      expect(result.ratingValue, '4.8');
      expect(result.restaurantLogo, 'GK');
    },
  );

  test('uses localized Arabic labels and value formats', () {
    final locale = AppLocalizationsAr();
    final result = SubscriptionMealDetailsPresentationMapper.map(
      meal: _meal,
      locale: locale,
    );

    expect(result.ratingTitle, locale.meal_details_restaurant_rating);
    expect(result.programLabel, locale.meal_details_meal_type);
    expect(result.deliveryLabel, locale.meal_details_delivery_time);
    expect(result.nutritionTitle, locale.meal_details_nutrition_facts);
    expect(
      result.macroDistributionTitle,
      locale.meal_details_macro_distribution,
    );
    expect(result.allergensTitle, locale.meal_details_allergens);
    expect(result.nutritionItems.first.label, locale.nutrition_details_fiber);
    expect(result.nutritionItems.first.value, '3.5 جم');
    expect(result.macroItems.first.percent, '%20');
  });
}

const _nutrition = SubscriptionMealNutritionDetailsEntity(
  calories: 420,
  proteinG: 40,
  carbsG: 35.5,
  fatG: 10,
  fiberG: 3.5,
  carbsPercent: 40,
  proteinPercent: 40,
  fatPercent: 20,
);

const _meal = SubscriptionMealDetailsEntity(
  mealId: 'meal-1',
  nameAr: 'وجبة دجاج',
  nameEn: 'Chicken bowl',
  descriptionAr: 'دجاج وأرز مشوي',
  descriptionEn: 'Grilled chicken and rice',
  imageUrl: 'https://example.com/meal.jpg',
  slot: 'lunch',
  slotNameAr: 'غداء',
  slotNameEn: 'Lunch',
  restaurantId: 'restaurant-1',
  restaurantNameAr: 'المطبخ الأخضر',
  restaurantNameEn: 'Green Kitchen',
  restaurantLogoUrl: 'https://example.com/logo.jpg',
  restaurantRating: 4.5,
  restaurantRatingCount: 12,
  deliveryWindowStart: '12:00',
  deliveryWindowEnd: '13:00',
  ingredients: [
    SubscriptionMealIngredientDetailsEntity(
      ingredientId: 'ingredient-1',
      nameAr: 'دجاج',
      nameEn: 'Chicken',
      category: 'poultry',
      isCore: true,
      iconUrl: null,
    ),
  ],
  nutrition: _nutrition,
  allergens: [
    SubscriptionMealAllergenDetailsEntity(
      nameAr: 'جلوتين',
      nameEn: 'Gluten',
      type: 'wheat',
    ),
  ],
);

const _mealWithoutRating = SubscriptionMealDetailsEntity(
  mealId: 'meal-1',
  nameAr: 'وجبة دجاج',
  nameEn: 'Chicken bowl',
  descriptionAr: 'دجاج وأرز مشوي',
  descriptionEn: 'Grilled chicken and rice',
  imageUrl: null,
  slot: 'lunch',
  slotNameAr: 'غداء',
  slotNameEn: 'Lunch',
  restaurantId: 'restaurant-1',
  restaurantNameAr: 'المطبخ الأخضر',
  restaurantNameEn: 'Green Kitchen',
  restaurantLogoUrl: null,
  restaurantRating: null,
  restaurantRatingCount: 0,
  deliveryWindowStart: null,
  deliveryWindowEnd: null,
  ingredients: [],
  nutrition: _nutrition,
  allergens: [],
);
