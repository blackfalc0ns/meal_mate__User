import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_dietary_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FoodPreferencesDietaryRequestDto {
  const FoodPreferencesDietaryRequestDto({
    required this.dietaryPreferenceCodes,
  });

  final List<String> dietaryPreferenceCodes;

  Map<String, dynamic> toJson() {
    final codes =
        dietaryPreferenceCodes.where((c) => c.trim().isNotEmpty).toList();
    return {
      'dietaryPreferenceCodes': codes.isEmpty ? const ['NONE'] : codes,
    };
  }
}
