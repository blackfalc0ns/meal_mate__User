import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_catalog_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FoodPreferencesCatalogResponseDto {
  const FoodPreferencesCatalogResponseDto({this.ingredients, this.allergens});

  final List<FoodPreferencesCatalogIngredientResponseDto>? ingredients;
  final List<FoodPreferencesCatalogAllergenResponseDto>? allergens;

  factory FoodPreferencesCatalogResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FoodPreferencesCatalogResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FoodPreferencesCatalogIngredientResponseDto {
  const FoodPreferencesCatalogIngredientResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.category,
    this.allergenCodes,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? category;
  final List<String>? allergenCodes;

  factory FoodPreferencesCatalogIngredientResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FoodPreferencesCatalogIngredientResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FoodPreferencesCatalogAllergenResponseDto {
  const FoodPreferencesCatalogAllergenResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory FoodPreferencesCatalogAllergenResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FoodPreferencesCatalogAllergenResponseDtoFromJson(json);
}
