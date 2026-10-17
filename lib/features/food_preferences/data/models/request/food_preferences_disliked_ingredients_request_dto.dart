import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

part 'food_preferences_disliked_ingredients_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FoodPreferencesDislikedIngredientsRequestDto {
  const FoodPreferencesDislikedIngredientsRequestDto({
    required this.ingredientCodes,
  });

  final List<String> ingredientCodes;

  Map<String, dynamic> toJson() {
    final cleanCodes = ingredientCodes
        .where(
          (c) =>
              c.trim().isNotEmpty &&
              c.trim().toUpperCase() != FoodPreferenceItemEntity.noneCode,
        )
        .toList();
    return {
      'ingredientCodes': cleanCodes,
      'selectedCodes': cleanCodes,
      'dislikedIngredients': cleanCodes,
      'dislikedFoods': cleanCodes,
      'eatsEverything': cleanCodes.isEmpty,
    };
  }
}

