import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FoodPreferencesResponseDto {
  const FoodPreferencesResponseDto({
    this.dietaryPattern,
    this.allergies,
    this.dislikedFoods,
    this.notes,
  });

  final String? dietaryPattern;
  final List<FoodPreferenceItemResponseDto>? allergies;
  final List<FoodPreferenceItemResponseDto>? dislikedFoods;
  final String? notes;

  factory FoodPreferencesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FoodPreferencesResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FoodPreferenceItemResponseDto {
  const FoodPreferenceItemResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.severity,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? severity;

  factory FoodPreferenceItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FoodPreferenceItemResponseDtoFromJson(json);
}
