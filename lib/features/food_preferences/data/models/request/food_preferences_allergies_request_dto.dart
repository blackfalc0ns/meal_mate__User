import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';

part 'food_preferences_allergies_request_dto.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class FoodPreferencesAllergiesRequestDto {
  const FoodPreferencesAllergiesRequestDto({required this.allergies});

  final List<FoodPreferenceItemRequestDto> allergies;

  Map<String, dynamic> toJson() =>
      _$FoodPreferencesAllergiesRequestDtoToJson(this);
}
