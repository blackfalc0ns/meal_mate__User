import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FoodPreferencesRequestDto {
  const FoodPreferencesRequestDto({
    this.dietaryPattern,
    required this.allergies,
    required this.dislikedFoods,
    this.notes,
  });

  final String? dietaryPattern;
  final List<FoodPreferenceItemRequestDto> allergies;
  final List<FoodPreferenceItemRequestDto> dislikedFoods;
  final String? notes;

  Map<String, dynamic> toJson() => _$FoodPreferencesRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class FoodPreferenceItemRequestDto {
  const FoodPreferenceItemRequestDto({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.severity,
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final String? severity;

  Map<String, dynamic> toJson() => _$FoodPreferenceItemRequestDtoToJson(this);
}
