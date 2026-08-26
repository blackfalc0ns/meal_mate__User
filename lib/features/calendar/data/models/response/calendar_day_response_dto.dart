import 'package:json_annotation/json_annotation.dart';

part 'calendar_day_response_dto.g.dart';

@JsonSerializable()
class CalendarDayResponseDto {
  const CalendarDayResponseDto({
    this.id,
    this.date,
    this.serviceDate,
    this.status,
    this.isLocked,
    this.lockedAtUtc,
    this.editDeadlineUtc,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurant,
    this.selectedMealIds,
    this.selectedMeals,
    this.meals,
    this.slotRequirements,
    this.canEdit,
    this.selectionDeadlineUtc,
    this.lockAtUtc,
  });

  final String? id;
  final String? date;
  final String? serviceDate;
  final String? status;
  final bool? isLocked;
  final String? lockedAtUtc;
  final String? editDeadlineUtc;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final CalendarRestaurantResponseDto? restaurant;
  final List<String>? selectedMealIds;
  final List<CalendarMealResponseDto>? selectedMeals;
  final List<CalendarMealResponseDto>? meals;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;
  final bool? canEdit;
  final String? selectionDeadlineUtc;
  final String? lockAtUtc;

  factory CalendarDayResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarDayResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarRestaurantsResponseDto {
  const CalendarRestaurantsResponseDto({
    this.restaurantPoolSnapshotId,
    this.eligibilityCheckedAtUtc,
    this.restaurantCount,
    this.restaurants,
  });

  final String? restaurantPoolSnapshotId;
  final String? eligibilityCheckedAtUtc;
  final int? restaurantCount;
  final List<CalendarRestaurantResponseDto>? restaurants;

  factory CalendarRestaurantsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarRestaurantsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarRestaurantsResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarRestaurantResponseDto {
  const CalendarRestaurantResponseDto({
    this.id,
    this.restaurantId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.description,
    this.descriptionAr,
    this.descriptionEn,
    this.category,
    this.categoryAr,
    this.categoryEn,
    this.rating,
    this.logoUrl,
    this.imageUrl,
    this.mealCount,
    this.safeMealCount,
    this.deliveryDuration,
    this.deliveryWindow,
    this.maxUsageCount,
  });

  final String? id;
  final String? restaurantId;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? description;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? category;
  final String? categoryAr;
  final String? categoryEn;
  final num? rating;
  final String? logoUrl;
  final String? imageUrl;
  final int? mealCount;
  final int? safeMealCount;
  final String? deliveryDuration;
  final String? deliveryWindow;
  final int? maxUsageCount;

  factory CalendarRestaurantResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarRestaurantResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarRestaurantResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarMealResponseDto {
  const CalendarMealResponseDto({
    this.id,
    this.mealId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.title,
    this.description,
    this.slot,
    this.slotName,
    this.slotNameAr,
    this.slotNameEn,
    this.mealType,
    this.time,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.imageUrl,
    this.ingredients,
    this.blockReason,
    this.isSelected,
  });

  final String? id;
  final String? mealId;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? title;
  final String? description;
  final String? slot;
  final String? slotName;
  final String? slotNameAr;
  final String? slotNameEn;
  final String? mealType;
  final String? time;
  final int? calories;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final String? imageUrl;
  final List<CalendarIngredientResponseDto>? ingredients;
  final String? blockReason;
  final bool? isSelected;

  factory CalendarMealResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarMealResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarMealResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarIngredientResponseDto {
  const CalendarIngredientResponseDto({
    this.id,
    this.name,
    this.nameAr,
    this.nameEn,
    this.category,
    this.iconUrl,
  });

  final String? id;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? category;
  final String? iconUrl;

  factory CalendarIngredientResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarIngredientResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarIngredientResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarSlotRequirementResponseDto {
  const CalendarSlotRequirementResponseDto({
    this.slot,
    this.slotName,
    this.slotNameAr,
    this.slotNameEn,
    this.count,
  });

  final String? slot;
  final String? slotName;
  final String? slotNameAr;
  final String? slotNameEn;
  final int? count;

  factory CalendarSlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarSlotRequirementResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarSlotRequirementResponseDtoToJson(this);
}
