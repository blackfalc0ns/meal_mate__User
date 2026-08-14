import 'package:json_annotation/json_annotation.dart';

part 'subscription_restaurant_details_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantDetailsResponseDto {
  const SubscriptionRestaurantDetailsResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.coverImageUrl,
    this.ingredientOrigins,
    this.mealGroups,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final String? coverImageUrl;
  final List<SubscriptionRestaurantIngredientOriginResponseDto>?
  ingredientOrigins;
  final List<SubscriptionRestaurantMealGroupResponseDto>? mealGroups;

  factory SubscriptionRestaurantDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionRestaurantDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantIngredientOriginResponseDto {
  const SubscriptionRestaurantIngredientOriginResponseDto({
    this.category,
    this.nameAr,
    this.nameEn,
    this.isLocal,
    this.sourceAr,
    this.sourceEn,
    this.originCountryCode,
    this.originCountryNameAr,
    this.originCountryNameEn,
    this.flagEmoji,
    this.iconUrl,
  });

  final String? category;
  final String? nameAr;
  final String? nameEn;
  final bool? isLocal;
  final String? sourceAr;
  final String? sourceEn;
  final String? originCountryCode;
  final String? originCountryNameAr;
  final String? originCountryNameEn;
  final String? flagEmoji;
  final String? iconUrl;

  factory SubscriptionRestaurantIngredientOriginResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionRestaurantIngredientOriginResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantMealGroupResponseDto {
  const SubscriptionRestaurantMealGroupResponseDto({
    this.slot,
    this.nameAr,
    this.nameEn,
    this.meals,
  });

  final String? slot;
  final String? nameAr;
  final String? nameEn;
  final List<SubscriptionRestaurantMealResponseDto>? meals;

  factory SubscriptionRestaurantMealGroupResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionRestaurantMealGroupResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantMealResponseDto {
  const SubscriptionRestaurantMealResponseDto({
    this.mealId,
    this.nameAr,
    this.nameEn,
    this.imageUrl,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.ingredients,
  });

  final String? mealId;
  final String? nameAr;
  final String? nameEn;
  final String? imageUrl;
  final int? calories;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final List<SubscriptionRestaurantMealIngredientResponseDto>? ingredients;

  factory SubscriptionRestaurantMealResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionRestaurantMealResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantMealIngredientResponseDto {
  const SubscriptionRestaurantMealIngredientResponseDto({
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

  factory SubscriptionRestaurantMealIngredientResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionRestaurantMealIngredientResponseDtoFromJson(json);
}
