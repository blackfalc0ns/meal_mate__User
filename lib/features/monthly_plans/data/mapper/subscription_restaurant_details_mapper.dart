import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_restaurant_details_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';

extension SubscriptionRestaurantDetailsResponseDtoMapper
    on SubscriptionRestaurantDetailsResponseDto {
  SubscriptionRestaurantDetailsEntity toEntity() {
    return SubscriptionRestaurantDetailsEntity(
      restaurantId: restaurantId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      ingredientOrigins: (ingredientOrigins ?? const [])
          .map((origin) => origin.toEntity())
          .toList(),
      mealGroups: (mealGroups ?? const [])
          .map((group) => group.toEntity())
          .where((group) => group.meals.isNotEmpty)
          .toList(),
    );
  }
}

extension SubscriptionRestaurantIngredientOriginResponseDtoMapper
    on SubscriptionRestaurantIngredientOriginResponseDto {
  SubscriptionRestaurantIngredientOriginEntity toEntity() {
    return SubscriptionRestaurantIngredientOriginEntity(
      category: category ?? 'other',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      isLocal: isLocal ?? false,
      sourceAr: sourceAr ?? '',
      sourceEn: sourceEn ?? sourceAr ?? '',
      originCountryCode: originCountryCode ?? '',
      originCountryNameAr: originCountryNameAr ?? '',
      originCountryNameEn: originCountryNameEn ?? originCountryNameAr ?? '',
      flagEmoji: flagEmoji ?? '',
      iconUrl: iconUrl,
    );
  }
}

extension SubscriptionRestaurantMealGroupResponseDtoMapper
    on SubscriptionRestaurantMealGroupResponseDto {
  SubscriptionRestaurantMealGroupEntity toEntity() {
    return SubscriptionRestaurantMealGroupEntity(
      slot: slot ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      meals: (meals ?? const []).map((meal) => meal.toEntity()).toList(),
    );
  }
}

extension SubscriptionRestaurantMealResponseDtoMapper
    on SubscriptionRestaurantMealResponseDto {
  SubscriptionRestaurantMealEntity toEntity() {
    return SubscriptionRestaurantMealEntity(
      mealId: mealId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      imageUrl: imageUrl,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      ingredients: (ingredients ?? const [])
          .map((ingredient) => ingredient.toEntity())
          .toList(),
    );
  }
}

extension SubscriptionRestaurantMealIngredientResponseDtoMapper
    on SubscriptionRestaurantMealIngredientResponseDto {
  SubscriptionRestaurantMealIngredientEntity toEntity() {
    return SubscriptionRestaurantMealIngredientEntity(
      ingredientId: ingredientId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? nameAr ?? '',
      category: category ?? 'other',
      isCore: isCore ?? false,
      iconUrl: iconUrl,
    );
  }
}
