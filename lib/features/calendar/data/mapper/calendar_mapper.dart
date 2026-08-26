import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';

extension CalendarDayResponseDtoMapper on CalendarDayResponseDto {
  CalendarDayEntity toEntity(String localeName) {
    final parsedDate = _parseDate(serviceDate ?? date);
    final selectedRestaurant =
        restaurant?.toRestaurantEntity(localeName) ??
        _flatRestaurantEntity(localeName);
    final dayMeals = selectedMeals ?? meals ?? const [];
    final sortedDayMeals = _sortedMeals(dayMeals);
    final resolvedSelectedMealIds =
        selectedMealIds ?? _selectedMealIds(sortedDayMeals);
    return CalendarDayEntity(
      id: id ?? '',
      status: status ?? '',
      restaurantId: restaurantId ?? selectedRestaurant?.id,
      restaurant: selectedRestaurant,
      meals: sortedDayMeals
          .map((meal) => meal.toMealEntity(localeName, resolvedSelectedMealIds))
          .toList(),
      selectedMealIds: resolvedSelectedMealIds,
      nutritionTotals: _nutritionTotalsEntity(),
      slotRequirements: (slotRequirements ?? const [])
          .map((requirement) => requirement.toEntity())
          .where(
            (requirement) =>
                requirement.slot.isNotEmpty && requirement.count > 0,
          )
          .toList(),
      isLocked: isLocked ?? !(canEdit ?? true),
      editDeadlineUtc: _parseDateTime(
        selectionDeadlineUtc ?? editDeadlineUtc ?? lockAtUtc ?? lockedAtUtc,
      ),
      dayNumber: parsedDate?.day ?? 0,
      weekday: parsedDate == null
          ? ''
          : DateFormat.E(localeName).format(parsedDate),
      date: parsedDate,
      hasMeals: true,
    );
  }

  CalendarRestaurantEntity? _flatRestaurantEntity(String localeName) {
    if ((restaurantId == null || restaurantId!.isEmpty) &&
        (restaurantName == null || restaurantName!.isEmpty) &&
        (restaurantNameAr == null || restaurantNameAr!.isEmpty) &&
        (restaurantNameEn == null || restaurantNameEn!.isEmpty) &&
        (restaurantLogoUrl == null || restaurantLogoUrl!.isEmpty)) {
      return null;
    }

    return CalendarRestaurantEntity(
      id: restaurantId ?? '',
      logoUrl: restaurantLogoUrl,
      name: _localized(
        localeName,
        ar: restaurantNameAr,
        en: restaurantNameEn,
        fallback: restaurantName ?? restaurantNameEn ?? restaurantNameAr,
      ),
      category: '',
      rating: '',
      deliveryDuration: '',
      deliveryWindow: '',
    );
  }
}

extension CalendarRestaurantResponseDtoMapper on CalendarRestaurantResponseDto {
  CalendarRestaurantEntity toRestaurantEntity(String localeName) {
    return CalendarRestaurantEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      maxUsageCount: maxUsageCount,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      category: _localized(
        localeName,
        ar: categoryAr,
        en: categoryEn,
        fallback: category,
      ),
      rating: rating?.toString() ?? '',
      deliveryDuration: deliveryDuration ?? '',
      deliveryWindow: deliveryWindow ?? '',
    );
  }

  CalendarRestaurantOptionEntity toOptionEntity(
    String localeName, {
    bool isUsageLimitReached = false,
    int? calculatedMaxUsageCount,
  }) {
    return CalendarRestaurantOptionEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      maxUsageCount: maxUsageCount ?? calculatedMaxUsageCount,
      isUsageLimitReached: isUsageLimitReached,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      description: _localized(
        localeName,
        ar: descriptionAr,
        en: descriptionEn,
        fallback: description,
      ),
      mealCount: safeMealCount ?? mealCount ?? 0,
      rating: rating?.toString() ?? '',
      logoType: CalendarRestaurantLogoType.healthyBowl,
    );
  }
}

extension CalendarMealResponseDtoMapper on CalendarMealResponseDto {
  CalendarMealEntity toMealEntity(String localeName, List<String> selectedIds) {
    final resolvedId = _firstNotEmpty([mealId, id]);
    final nutritionCalories = _wholeNumber(nutrition?.calories);
    final nutritionProtein = _wholeNumber(nutrition?.proteinG);
    final nutritionCarbs = _wholeNumber(nutrition?.carbsG);
    final nutritionFat = _wholeNumber(nutrition?.fatG);
    final ingredientItems = (ingredients ?? const [])
        .map((ingredient) => ingredient.toEntity(localeName))
        .where((ingredient) => ingredient.label.isNotEmpty)
        .take(5)
        .toList();

    return CalendarMealEntity(
      id: resolvedId,
      slot: slot ?? mealType ?? '',
      imageUrl: imageUrl,
      blockReason: blockReason,
      selected: (isSelected ?? false) || selectedIds.contains(resolvedId),
      description: _localized(
        localeName,
        ar: descriptionAr,
        en: descriptionEn,
        fallback: description,
      ),
      mealType: _localized(
        localeName,
        ar: slotNameAr,
        en: slotNameEn,
        fallback: slotName ?? mealType ?? slot,
      ),
      title: _localized(
        localeName,
        ar: nameAr,
        en: nameEn,
        fallback: name ?? title,
      ),
      time: time ?? '',
      calories: (nutritionCalories ?? calories)?.toString() ?? '',
      protein: (nutritionProtein ?? proteinG)?.toString() ?? '',
      carbs: (nutritionCarbs ?? carbsG)?.toString() ?? '',
      fat: (nutritionFat ?? fatG)?.toString() ?? '',
      ingredients: ingredientItems,
      imageAsset: Assets.calendarMealPickerHero,
      actionLabel: '',
    );
  }
}

extension CalendarIngredientResponseDtoMapper on CalendarIngredientResponseDto {
  CalendarMealIngredientEntity toEntity(String localeName) {
    return CalendarMealIngredientEntity(
      label: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      asset: Assets.calendarMealPickerHero,
      iconUrl: iconUrl,
    );
  }
}

extension CalendarSlotRequirementResponseDtoMapper
    on CalendarSlotRequirementResponseDto {
  CalendarSlotRequirementEntity toEntity() {
    return CalendarSlotRequirementEntity(
      slot: slot ?? '',
      slotNameAr: slotNameAr ?? slotName ?? '',
      slotNameEn: slotNameEn ?? slotName ?? slotNameAr ?? '',
      count: count ?? 0,
    );
  }
}

extension CalendarAvailableMealsResponseDtoMapper
    on CalendarAvailableMealsResponseDto {
  CalendarAvailableMealsEntity toEntity(String localeName) {
    return CalendarAvailableMealsEntity(
      restaurant:
          restaurant?.toRestaurantEntity(localeName) ??
          _flatRestaurantEntity(localeName),
      meals: (meals ?? const [])
          .map((meal) => meal.toMealEntity(localeName, const []))
          .where((meal) => meal.id.isNotEmpty)
          .toList(),
      slotRequirements: (slotRequirements ?? const [])
          .map((requirement) => requirement.toEntity())
          .where(
            (requirement) =>
                requirement.slot.isNotEmpty && requirement.count > 0,
          )
          .toList(),
    );
  }

  CalendarRestaurantEntity? _flatRestaurantEntity(String localeName) {
    if ((restaurantId == null || restaurantId!.isEmpty) &&
        (nameAr == null || nameAr!.isEmpty) &&
        (nameEn == null || nameEn!.isEmpty)) {
      return null;
    }

    return CalendarRestaurantEntity(
      id: restaurantId ?? '',
      logoUrl: logoUrl,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: nameEn),
      category: '',
      rating: '',
      deliveryDuration: '',
      deliveryWindow: '',
    );
  }
}

extension CalendarResponseMapper on CalendarResponseDto {
  CalendarSubscriptionEntity toSubscriptionEntity({
    required String subscriptionId,
    required String localeName,
  }) {
    final globalSlotRequirements = slotRequirements ?? const [];
    final mappedDays =
        (days ?? const [])
            .map((day) => _withGlobalSlots(day, globalSlotRequirements))
            .map((day) => day.toEntity(localeName))
            .where((day) => day.date != null)
            .toList()
          ..sort((a, b) => a.date!.compareTo(b.date!));

    return CalendarSubscriptionEntity(
      subscriptionId: this.subscriptionId ?? subscriptionId,
      days: mappedDays,
    );
  }

  CalendarDayResponseDto _withGlobalSlots(
    CalendarDayResponseDto day,
    List<CalendarSlotRequirementResponseDto> globalSlotRequirements,
  ) {
    if (day.slotRequirements != null || globalSlotRequirements.isEmpty) {
      return day;
    }

    return CalendarDayResponseDto(
      id: day.id,
      date: day.date,
      serviceDate: day.serviceDate,
      status: day.status,
      isLocked: day.isLocked,
      lockedAtUtc: day.lockedAtUtc,
      editDeadlineUtc: day.editDeadlineUtc,
      restaurantId: day.restaurantId,
      restaurantName: day.restaurantName,
      restaurantNameAr: day.restaurantNameAr,
      restaurantNameEn: day.restaurantNameEn,
      restaurantLogoUrl: day.restaurantLogoUrl,
      restaurant: day.restaurant,
      selectedMealIds: day.selectedMealIds,
      selectedMeals: day.selectedMeals,
      nutritionTotals: day.nutritionTotals,
      meals: day.meals,
      slotRequirements: globalSlotRequirements,
      canEdit: day.canEdit,
      selectionDeadlineUtc: day.selectionDeadlineUtc,
      lockAtUtc: day.lockAtUtc,
    );
  }
}

extension CalendarNutritionResponseDtoMapper on CalendarNutritionResponseDto {
  CalendarNutritionTotalsEntity toTotalsEntity() {
    return CalendarNutritionTotalsEntity(
      calories: _wholeNumber(calories) ?? 0,
      proteinG: _wholeNumber(proteinG) ?? 0,
      carbsG: _wholeNumber(carbsG) ?? 0,
      fatG: _wholeNumber(fatG) ?? 0,
    );
  }
}

extension CalendarSetRestaurantRequestMapper on String {
  CalendarSetRestaurantRequestDto toSetRestaurantDto() {
    return CalendarSetRestaurantRequestDto(restaurantId: this);
  }
}

extension CalendarMealRequestMapper on CalendarMealEntity {
  CalendarSaveMealsRequestDto toSaveMealsDto() {
    return CalendarSaveMealsRequestDto(mealId: id, slot: slot.toLowerCase());
  }
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

DateTime? _parseDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

List<CalendarMealResponseDto> _sortedMeals(
  List<CalendarMealResponseDto> meals,
) {
  final sortedMeals = List<CalendarMealResponseDto>.from(meals);
  sortedMeals.sort((a, b) {
    final aOrder = a.sortOrder;
    final bOrder = b.sortOrder;
    if (aOrder == null && bOrder == null) return 0;
    if (aOrder == null) return 1;
    if (bOrder == null) return -1;
    return aOrder.compareTo(bOrder);
  });
  return sortedMeals;
}

List<String> _selectedMealIds(List<CalendarMealResponseDto> meals) {
  return meals
      .where((meal) => meal.isSelected ?? true)
      .map((meal) => _firstNotEmpty([meal.mealId, meal.id]))
      .where((id) => id.isNotEmpty)
      .toList();
}

extension _CalendarDayNutritionTotalsMapper on CalendarDayResponseDto {
  CalendarNutritionTotalsEntity _nutritionTotalsEntity() {
    final totals = nutritionTotals;
    if (totals != null) return totals.toTotalsEntity();

    final mealsForTotals = selectedMeals ?? _fallbackSelectedMealsForTotals();
    return mealsForTotals.fold(
      const CalendarNutritionTotalsEntity(),
      (total, meal) => CalendarNutritionTotalsEntity(
        calories:
            total.calories +
            (_wholeNumber(meal.nutrition?.calories) ?? meal.calories ?? 0),
        proteinG:
            total.proteinG +
            (_wholeNumber(meal.nutrition?.proteinG) ?? meal.proteinG ?? 0),
        carbsG:
            total.carbsG +
            (_wholeNumber(meal.nutrition?.carbsG) ?? meal.carbsG ?? 0),
        fatG:
            total.fatG + (_wholeNumber(meal.nutrition?.fatG) ?? meal.fatG ?? 0),
      ),
    );
  }

  List<CalendarMealResponseDto> _fallbackSelectedMealsForTotals() {
    final dayMeals = meals ?? const [];
    final selectedIds = selectedMealIds ?? const [];
    if (selectedIds.isNotEmpty) {
      return dayMeals
          .where(
            (meal) =>
                selectedIds.contains(_firstNotEmpty([meal.mealId, meal.id])),
          )
          .toList();
    }
    return dayMeals.where((meal) => meal.isSelected ?? false).toList();
  }
}

String _localized(
  String localeName, {
  String? ar,
  String? en,
  String? fallback,
}) {
  final value = localeName.startsWith('ar')
      ? ar ?? fallback ?? en
      : en ?? fallback ?? ar;
  return value ?? '';
}

String _firstNotEmpty(List<String?> values) {
  return _firstNullableNotEmpty(values) ?? '';
}

String? _firstNullableNotEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

int? _wholeNumber(num? value) {
  if (value == null) return null;
  return value.round();
}
