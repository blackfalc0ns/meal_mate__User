import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

extension FoodPreferencesResponseDtoMapper on FoodPreferencesResponseDto {
  FoodPreferencesEntity toEntity() {
    return FoodPreferencesEntity(
      dietaryPattern: dietaryPattern,
      allergies: allergies?.map((item) => item.toEntity()).toList() ?? const [],
      dislikedFoods:
          dislikedFoods?.map((item) => item.toEntity()).toList() ?? const [],
      notes: notes,
    );
  }
}

extension FoodPreferenceItemResponseDtoMapper on FoodPreferenceItemResponseDto {
  FoodPreferenceItemEntity toEntity() {
    return FoodPreferenceItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      severity: severity,
    );
  }
}

extension FoodPreferencesEntityMapper on FoodPreferencesEntity {
  FoodPreferencesRequestDto toDto() {
    return FoodPreferencesRequestDto(
      dietaryPattern: dietaryPattern,
      allergies: allergies.map((item) => item.toDto()).toList(),
      dislikedFoods: dislikedFoods.map((item) => item.toDto()).toList(),
      notes: notes,
    );
  }
}

extension FoodPreferenceItemEntityMapper on FoodPreferenceItemEntity {
  FoodPreferenceItemRequestDto toDto() {
    return FoodPreferenceItemRequestDto(
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      severity: severity,
    );
  }
}
