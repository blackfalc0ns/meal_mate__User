import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

part 'calendar_available_meals_response_dto.g.dart';

@JsonSerializable()
class CalendarAvailableMealsResponseDto {
  const CalendarAvailableMealsResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.restaurant,
    this.meals,
    this.slotRequirements,
    this.coreIngredients,
    this.selectedMealIds,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final CalendarRestaurantResponseDto? restaurant;
  final List<CalendarMealResponseDto>? meals;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;
  final List<CalendarCoreIngredientResponseDto>? coreIngredients;
  final List<String>? selectedMealIds;

  factory CalendarAvailableMealsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarAvailableMealsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarAvailableMealsResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarCoreIngredientResponseDto {
  const CalendarCoreIngredientResponseDto({
    this.id,
    this.name,
    this.nameAr,
    this.nameEn,
    this.iconUrl,
    this.isLocal,
    this.originCountryCode,
    this.originCountryName,
    this.originCountryNameAr,
    this.originCountryNameEn,
    this.flagEmoji,
  });

  final String? id;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? iconUrl;
  final bool? isLocal;
  final String? originCountryCode;
  final String? originCountryName;
  final String? originCountryNameAr;
  final String? originCountryNameEn;
  final String? flagEmoji;

  factory CalendarCoreIngredientResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarCoreIngredientResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarCoreIngredientResponseDtoToJson(this);
}
