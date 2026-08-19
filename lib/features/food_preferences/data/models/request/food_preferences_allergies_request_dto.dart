import 'package:json_annotation/json_annotation.dart';
part 'food_preferences_allergies_request_dto.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class FoodPreferencesAllergiesRequestDto {
  const FoodPreferencesAllergiesRequestDto({required this.allergies});

  final List<FoodPreferencesAllergyRequestDto> allergies;

  Map<String, dynamic> toJson() =>
      _$FoodPreferencesAllergiesRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class FoodPreferencesAllergyRequestDto {
  const FoodPreferencesAllergyRequestDto({required this.code, this.severity});

  final String code;
  final String? severity;

  Map<String, dynamic> toJson() =>
      _$FoodPreferencesAllergyRequestDtoToJson(this);
}
