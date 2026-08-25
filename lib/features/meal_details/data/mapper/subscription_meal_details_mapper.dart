import 'package:meal_meat_user/features/meal_details/data/models/response/subscription_meal_details_response_dto.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';

extension SubscriptionMealDetailsResponseDtoMapper
    on SubscriptionMealDetailsResponseDto {
  SubscriptionMealDetailsEntity toEntity() {
    return SubscriptionMealDetailsEntity(
      mealId: mealId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      descriptionAr: descriptionAr ?? '',
      descriptionEn: descriptionEn ?? descriptionAr ?? '',
      imageUrl: imageUrl,
      slot: slot ?? '',
      slotNameAr: slotNameAr ?? '',
      slotNameEn: slotNameEn ?? slotNameAr ?? '',
      restaurantId: restaurantId ?? '',
      restaurantNameAr: restaurantNameAr ?? '',
      restaurantNameEn: restaurantNameEn ?? restaurantNameAr ?? '',
      restaurantLogoUrl: restaurantLogoUrl,
      restaurantRating: restaurantRating,
      restaurantRatingCount: restaurantRatingCount ?? 0,
      deliveryWindowStart: deliveryWindowStart,
      deliveryWindowEnd: deliveryWindowEnd,
      ingredients: (ingredients ?? const [])
          .map((ingredient) => ingredient.toEntity())
          .toList(),
      nutrition:
          nutrition?.toEntity() ??
          const SubscriptionMealNutritionDetailsEntity(
            calories: null,
            proteinG: null,
            carbsG: null,
            fatG: null,
            fiberG: null,
            carbsPercent: null,
            proteinPercent: null,
            fatPercent: null,
          ),
      allergens: (allergens ?? const [])
          .map((allergen) => allergen.toEntity())
          .where(
            (allergen) =>
                allergen.nameAr.isNotEmpty || allergen.nameEn.isNotEmpty,
          )
          .toList(),
    );
  }
}

extension SubscriptionMealIngredientDetailsResponseDtoMapper
    on SubscriptionMealIngredientDetailsResponseDto {
  SubscriptionMealIngredientDetailsEntity toEntity() {
    return SubscriptionMealIngredientDetailsEntity(
      ingredientId: ingredientId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      category: category ?? 'other',
      isCore: isCore ?? false,
      iconUrl: iconUrl,
    );
  }
}

extension SubscriptionMealNutritionDetailsResponseDtoMapper
    on SubscriptionMealNutritionDetailsResponseDto {
  SubscriptionMealNutritionDetailsEntity toEntity() {
    return SubscriptionMealNutritionDetailsEntity(
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      fiberG: fiberG,
      carbsPercent: carbsPercent,
      proteinPercent: proteinPercent,
      fatPercent: fatPercent,
    );
  }
}

extension SubscriptionMealAllergenDetailsResponseDtoMapper
    on SubscriptionMealAllergenDetailsResponseDto {
  SubscriptionMealAllergenDetailsEntity toEntity() {
    return SubscriptionMealAllergenDetailsEntity(
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      type: type ?? '',
    );
  }
}
