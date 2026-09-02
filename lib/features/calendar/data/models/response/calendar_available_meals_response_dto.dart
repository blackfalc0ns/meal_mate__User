import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

part 'calendar_available_meals_response_dto.g.dart';

@JsonSerializable()
class CalendarAvailableMealsResponseDto {
  const CalendarAvailableMealsResponseDto({
    this.restaurantId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.serviceDate,
    this.requiredCount,
    this.filledCount,
    this.slots,
    this.coreIngredients,
    this.selectedMealIds,
    this.rating,
    this.ratingCount,
    this.deliveryWindowStart,
    this.deliveryWindowEnd,
    this.deliveryTimeText,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.tierName,
    this.tierLogoUrl,
    this.programNameAr,
    this.programNameEn,
    this.programName,
    this.restaurant,
    this.meals,
    this.slotRequirements,
  });

  final String? restaurantId;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final String? serviceDate;
  final int? requiredCount;
  final int? filledCount;
  final List<CalendarAvailableMealSlotResponseDto>? slots;
  final List<CalendarCoreIngredientResponseDto>? coreIngredients;
  final List<String>? selectedMealIds;
  final num? rating;
  final int? ratingCount;
  final String? deliveryWindowStart;
  final String? deliveryWindowEnd;
  final String? deliveryTimeText;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierName;
  final String? tierLogoUrl;
  final String? programNameAr;
  final String? programNameEn;
  final String? programName;
  final CalendarRestaurantResponseDto? restaurant;
  final List<CalendarMealResponseDto>? meals;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;

  factory CalendarAvailableMealsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarAvailableMealsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarAvailableMealsResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarAvailableMealSlotResponseDto {
  const CalendarAvailableMealSlotResponseDto({
    this.slot,
    this.slotName,
    this.slotNameAr,
    this.slotNameEn,
    this.count,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.meals,
  });

  final String? slot;
  final String? slotName;
  final String? slotNameAr;
  final String? slotNameEn;
  final int? count;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  final List<CalendarMealResponseDto>? meals;

  factory CalendarAvailableMealSlotResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarAvailableMealSlotResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarAvailableMealSlotResponseDtoToJson(this);
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
