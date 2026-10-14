import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_disliked_ingredients_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FoodPreferencesDislikedIngredientsRequestDto {
  const FoodPreferencesDislikedIngredientsRequestDto({
    required this.ingredientCodes,
  });

  final List<String> ingredientCodes;

  Map<String, dynamic> toJson() {
    final codes = ingredientCodes.where((c) => c.trim().isNotEmpty).toList();
    return {
      'ingredientCodes': codes.isEmpty ? const ['NONE'] : codes,
    };
  }
}
