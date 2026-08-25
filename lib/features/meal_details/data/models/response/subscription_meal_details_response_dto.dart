import 'package:json_annotation/json_annotation.dart';

part 'subscription_meal_details_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionMealDetailsResponseDto {
  const SubscriptionMealDetailsResponseDto({
    this.mealId,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.imageUrl,
    this.slot,
    this.slotNameAr,
    this.slotNameEn,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurantLogoUrl,
    this.restaurantRating,
    this.restaurantRatingCount,
    this.deliveryWindowStart,
    this.deliveryWindowEnd,
    this.ingredients,
    this.nutrition,
    this.allergens,
  });

  final String? mealId;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? imageUrl;
  final String? slot;
  final String? slotNameAr;
  final String? slotNameEn;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final String? restaurantLogoUrl;
  final double? restaurantRating;
  final int? restaurantRatingCount;
  final String? deliveryWindowStart;
  final String? deliveryWindowEnd;
  final List<SubscriptionMealIngredientDetailsResponseDto>? ingredients;
  final SubscriptionMealNutritionDetailsResponseDto? nutrition;
  final List<SubscriptionMealAllergenDetailsResponseDto>? allergens;

  factory SubscriptionMealDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionMealDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionMealIngredientDetailsResponseDto {
  const SubscriptionMealIngredientDetailsResponseDto({
    this.ingredientId,
    this.nameAr,
    this.nameEn,
    this.category,
    this.isCore,
    this.iconUrl,
  });

  final String? ingredientId;
  final String? nameAr;
  final String? nameEn;
  final String? category;
  final bool? isCore;
  final String? iconUrl;

  factory SubscriptionMealIngredientDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionMealIngredientDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionMealNutritionDetailsResponseDto {
  const SubscriptionMealNutritionDetailsResponseDto({
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.fiberG,
    this.carbsPercent,
    this.proteinPercent,
    this.fatPercent,
  });

  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final double? fiberG;
  final int? carbsPercent;
  final int? proteinPercent;
  final int? fatPercent;

  factory SubscriptionMealNutritionDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionMealNutritionDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionMealAllergenDetailsResponseDto {
  const SubscriptionMealAllergenDetailsResponseDto({
    this.nameAr,
    this.nameEn,
    this.type,
  });

  final String? nameAr;
  final String? nameEn;
  final String? type;

  factory SubscriptionMealAllergenDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionMealAllergenDetailsResponseDtoFromJson(json);
}
