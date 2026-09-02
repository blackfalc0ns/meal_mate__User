import 'package:json_annotation/json_annotation.dart';

part 'calendar_day_response_dto.g.dart';

@JsonSerializable()
class CalendarDayResponseDto {
  const CalendarDayResponseDto({
    this.id,
    this.date,
    this.serviceDate,
    this.status,
    this.uiStatus,
    this.isLocked,
    this.isAutoSelected,
    this.lockedAtUtc,
    this.editDeadlineUtc,
    this.restaurantId,
    this.restaurantName,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurantLogoUrl,
    this.restaurant,
    this.selectedMealIds,
    this.selectedMeals,
    this.nutritionTotals,
    this.meals,
    this.slotRequirements,
    this.canEdit,
    this.selectionDeadlineUtc,
    this.lockAtUtc,
    this.lockRemainingSeconds,
    this.filledCount,
    this.requiredCount,
    this.failureReasonCode,
    this.restaurantRating,
    this.restaurantRatingCount,
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
  });

  final String? id;
  final String? date;
  final String? serviceDate;
  final String? status;
  final String? uiStatus;
  final bool? isLocked;
  final bool? isAutoSelected;
  final String? lockedAtUtc;
  final String? editDeadlineUtc;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final String? restaurantLogoUrl;
  final CalendarRestaurantResponseDto? restaurant;
  final List<String>? selectedMealIds;
  final List<CalendarMealResponseDto>? selectedMeals;
  final CalendarNutritionResponseDto? nutritionTotals;
  final List<CalendarMealResponseDto>? meals;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;
  final bool? canEdit;
  final String? selectionDeadlineUtc;
  final String? lockAtUtc;
  final int? lockRemainingSeconds;
  final int? filledCount;
  final int? requiredCount;
  final String? failureReasonCode;
  final num? restaurantRating;
  final int? restaurantRatingCount;
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
    this.limit,
    this.usedCount,
    this.remainingCount,
    this.isBusy,
    this.isQuotaExhausted,
    this.isEnabled,
    this.disabledReason,
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
  final int? limit;
  final int? usedCount;
  final int? remainingCount;
  final bool? isBusy;
  final bool? isQuotaExhausted;
  final bool? isEnabled;
  final String? disabledReason;
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
    this.descriptionAr,
    this.descriptionEn,
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
    this.nutrition,
    this.imageUrl,
    this.ingredients,
    this.blockReason,
    this.isSelected,
    this.sortOrder,
  });

  final String? id;
  final String? mealId;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? title;
  final String? description;
  final String? descriptionAr;
  final String? descriptionEn;
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
  final CalendarNutritionResponseDto? nutrition;
  final String? imageUrl;
  final List<CalendarIngredientResponseDto>? ingredients;
  final String? blockReason;
  final bool? isSelected;
  final int? sortOrder;

  factory CalendarMealResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarMealResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarMealResponseDtoToJson(this);
}

@JsonSerializable()
class CalendarIngredientResponseDto {
  const CalendarIngredientResponseDto({
    this.id,
    this.ingredientId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.category,
    this.iconUrl,
  });

  final String? id;
  final String? ingredientId;
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
class CalendarNutritionResponseDto {
  const CalendarNutritionResponseDto({
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.fiberG,
    this.carbsPercent,
    this.proteinPercent,
    this.fatPercent,
  });

  final num? calories;
  final num? proteinG;
  final num? carbsG;
  final num? fatG;
  final num? fiberG;
  final int? carbsPercent;
  final int? proteinPercent;
  final int? fatPercent;

  factory CalendarNutritionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarNutritionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarNutritionResponseDtoToJson(this);
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
