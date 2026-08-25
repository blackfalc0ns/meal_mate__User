import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_dietary_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FoodPreferencesDietaryRequestDto {
  const FoodPreferencesDietaryRequestDto({
    required this.dietaryPreferenceCodes,
    required this.confirmed,
    required this.noneSelected,
  });

  final List<String> dietaryPreferenceCodes;
  final bool confirmed;
  final bool noneSelected;

  Map<String, dynamic> toJson() =>
      _$FoodPreferencesDietaryRequestDtoToJson(this);
}
