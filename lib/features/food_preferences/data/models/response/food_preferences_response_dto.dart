import 'package:json_annotation/json_annotation.dart';

part 'food_preferences_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FoodPreferencesResponseDto {
  const FoodPreferencesResponseDto({
    this.noneOption,
    this.dietaryPattern,
    this.dietaryPreferences,
    this.ingredients,
    this.allergens,
    this.allergies,
    this.dislikedFoods,
    this.items,
    this.selectedCount,
    this.eatsEverything,
    this.hasNoAllergies,
    this.hasNoDietaryRestriction,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.notes,
    this.allergiesCompletedAtUtc,
    this.dietaryPreferencesCompletedAtUtc,
  });

  final FoodPreferenceItemResponseDto? noneOption;
  final String? dietaryPattern;
  final List<FoodPreferenceItemResponseDto>? dietaryPreferences;
  final List<FoodPreferenceItemResponseDto>? ingredients;
  final List<FoodPreferenceItemResponseDto>? allergens;
  final List<FoodPreferenceItemResponseDto>? allergies;
  final List<FoodPreferenceItemResponseDto>? dislikedFoods;
  final List<FoodPreferenceItemResponseDto>? items;
  final int? selectedCount;
  final bool? eatsEverything;
  final bool? hasNoAllergies;
  final bool? hasNoDietaryRestriction;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  final String? notes;
  final String? allergiesCompletedAtUtc;
  final String? dietaryPreferencesCompletedAtUtc;

  factory FoodPreferencesResponseDto.fromJson(Map<String, dynamic> json) {
    final parsed = _$FoodPreferencesResponseDtoFromJson(json);
    final allergiesUtc =
        (json['allergiesCompletedAtUtc'] ?? json['AllergiesCompletedAtUtc'])
            as String? ??
        parsed.allergiesCompletedAtUtc;
    final dietaryUtc =
        (json['dietaryPreferencesCompletedAtUtc'] ??
                json['DietaryPreferencesCompletedAtUtc'])
            as String? ??
        parsed.dietaryPreferencesCompletedAtUtc;
    final itemsList = (json['items'] as List<dynamic>?)
        ?.map(
          (e) =>
              FoodPreferenceItemResponseDto.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    if (itemsList == null || itemsList.isEmpty) {
      return FoodPreferencesResponseDto(
        noneOption: parsed.noneOption,
        dietaryPattern: parsed.dietaryPattern,
        dietaryPreferences: parsed.dietaryPreferences,
        ingredients: parsed.ingredients,
        allergens: parsed.allergens,
        allergies: parsed.allergies,
        dislikedFoods: parsed.dislikedFoods,
        items: parsed.items,
        selectedCount: parsed.selectedCount,
        eatsEverything: parsed.eatsEverything,
        hasNoAllergies: parsed.hasNoAllergies,
        hasNoDietaryRestriction: parsed.hasNoDietaryRestriction,
        page: parsed.page,
        pageSize: parsed.pageSize,
        totalCount: parsed.totalCount,
        totalPages: parsed.totalPages,
        hasNextPage: parsed.hasNextPage,
        hasPreviousPage: parsed.hasPreviousPage,
        notes: parsed.notes,
        allergiesCompletedAtUtc: allergiesUtc,
        dietaryPreferencesCompletedAtUtc: dietaryUtc,
      );
    }
    return FoodPreferencesResponseDto(
      noneOption: parsed.noneOption,
      dietaryPattern: parsed.dietaryPattern,
      dietaryPreferences: parsed.dietaryPreferences ?? itemsList,
      ingredients: parsed.ingredients ?? itemsList,
      allergens: parsed.allergens ?? itemsList,
      allergies: parsed.allergies ?? itemsList,
      dislikedFoods: parsed.dislikedFoods ?? itemsList,
      items: itemsList,
      selectedCount: parsed.selectedCount,
      eatsEverything: parsed.eatsEverything,
      hasNoAllergies: parsed.hasNoAllergies,
      hasNoDietaryRestriction: parsed.hasNoDietaryRestriction,
      page: parsed.page,
      pageSize: parsed.pageSize,
      totalCount: parsed.totalCount,
      totalPages: parsed.totalPages,
      hasNextPage: parsed.hasNextPage,
      hasPreviousPage: parsed.hasPreviousPage,
      notes: parsed.notes,
      allergiesCompletedAtUtc: allergiesUtc,
      dietaryPreferencesCompletedAtUtc: dietaryUtc,
    );
  }
}

@JsonSerializable(createToJson: false)
class FoodPreferenceItemResponseDto {
  const FoodPreferenceItemResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.category,
    this.allergenCodes,
    this.isSelected,
    this.severity,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? category;
  final List<String>? allergenCodes;
  final bool? isSelected;
  final String? severity;

  factory FoodPreferenceItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FoodPreferenceItemResponseDtoFromJson(json);
}
