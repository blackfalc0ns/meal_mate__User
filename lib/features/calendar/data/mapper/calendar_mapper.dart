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
        _restaurantWithDayDelivery(
          restaurant?.toRestaurantEntity(localeName),
          localeName,
        ) ??
        _flatRestaurantEntity(localeName);
    final dayMeals = selectedMeals ?? meals ?? const [];
    final sortedDayMeals = _sortedMeals(dayMeals);
    final resolvedSelectedMealIds =
        selectedMealIds ?? _selectedMealIds(sortedDayMeals);
    return CalendarDayEntity(
      id: id ?? '',
      status: _firstNotEmpty([status, uiStatus]),
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
      weekday: parsedDate == null ? '' : _formatWeekday(parsedDate, localeName),
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
      logoUrl: _firstNullableNotEmpty([restaurantLogoUrl, tierLogoUrl]),
      tierLogoUrl: tierLogoUrl,
      ratingCount: restaurantRatingCount ?? 0,
      name: _localized(
        localeName,
        ar: restaurantNameAr,
        en: restaurantNameEn,
        fallback: restaurantName ?? restaurantNameEn ?? restaurantNameAr,
      ),
      category: _localized(
        localeName,
        ar: programNameAr,
        en: programNameEn,
        fallback: programName,
      ),
      rating: restaurantRating?.toString() ?? '4.5',
      deliveryDuration: _localized(
        localeName,
        ar: tierNameAr,
        en: tierNameEn,
        fallback: tierName ?? tier,
      ),
      deliveryWindow: _deliveryWindowText(
        deliveryTimeText: deliveryTimeText,
        deliveryWindowStart: deliveryWindowStart,
        deliveryWindowEnd: deliveryWindowEnd,
      ),
    );
  }

  CalendarRestaurantEntity? _restaurantWithDayDelivery(
    CalendarRestaurantEntity? restaurant,
    String localeName,
  ) {
    if (restaurant == null) return null;

    final dayDeliveryWindow = _deliveryWindowText(
      deliveryTimeText: deliveryTimeText,
      deliveryWindowStart: deliveryWindowStart,
      deliveryWindowEnd: deliveryWindowEnd,
    );
    final category = _localized(
      localeName,
      ar: programNameAr,
      en: programNameEn,
      fallback: programName,
    );
    final deliveryDuration = _localized(
      localeName,
      ar: tierNameAr,
      en: tierNameEn,
      fallback: tierName ?? tier,
    );
    final hasDayOverrides =
        (restaurant.deliveryWindow.trim().isEmpty &&
            dayDeliveryWindow.isNotEmpty) ||
        (restaurant.category.trim().isEmpty && category.isNotEmpty) ||
        (restaurant.deliveryDuration.trim().isEmpty &&
            deliveryDuration.isNotEmpty);

    if (!hasDayOverrides) {
      return restaurant;
    }

    return CalendarRestaurantEntity(
      id: restaurant.id,
      logoUrl: _firstNullableNotEmpty([restaurant.logoUrl, tierLogoUrl]),
      tierLogoUrl: _firstNullableNotEmpty([
        restaurant.tierLogoUrl,
        tierLogoUrl,
      ]),
      ratingCount: restaurant.ratingCount,
      maxUsageCount: restaurant.maxUsageCount,
      name: restaurant.name,
      category: _firstNotEmpty([restaurant.category, category]),
      rating: restaurant.rating,
      deliveryDuration: _firstNotEmpty([
        restaurant.deliveryDuration,
        deliveryDuration,
      ]),
      deliveryWindow: _firstNotEmpty([
        restaurant.deliveryWindow,
        dayDeliveryWindow,
      ]),
    );
  }
}

extension CalendarRestaurantResponseDtoMapper on CalendarRestaurantResponseDto {
  CalendarRestaurantEntity toRestaurantEntity(String localeName) {
    return CalendarRestaurantEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      tierLogoUrl: tierLogoUrl,
      ratingCount: ratingCount ?? 0,
      maxUsageCount: maxUsageCount,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      category: _localized(
        localeName,
        ar: categoryAr,
        en: categoryEn,
        fallback: category,
      ),
      rating: rating?.toString() ?? '4.5',
      deliveryDuration: _localized(
        localeName,
        ar: tierNameAr,
        en: tierNameEn,
        fallback: tierName ?? tier ?? deliveryDuration,
      ),
      deliveryWindow: _deliveryWindowText(
        deliveryTimeText: deliveryTimeText ?? deliveryWindow,
        deliveryWindowStart: deliveryWindowStart,
        deliveryWindowEnd: deliveryWindowEnd,
      ),
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
      tierLogoUrl: tierLogoUrl,
      maxUsageCount: maxUsageCount ?? limit ?? calculatedMaxUsageCount,
      usedCount: usedCount,
      remainingCount: remainingCount,
      isBusy: isBusy ?? false,
      isQuotaExhausted: isQuotaExhausted ?? false,
      isEnabled: isEnabled ?? true,
      disabledReason: disabledReason,
      isUsageLimitReached: isUsageLimitReached,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      description: _localized(
        localeName,
        ar: descriptionAr,
        en: descriptionEn,
        fallback: description,
      ),
      mealCount: safeMealCount ?? mealCount ?? 0,
      rating: rating?.toString() ?? '4.5',
      ratingCount: ratingCount ?? 0,
      deliveryWindow: _deliveryWindowText(
        deliveryTimeText: deliveryTimeText ?? deliveryWindow,
        deliveryWindowStart: deliveryWindowStart,
        deliveryWindowEnd: deliveryWindowEnd,
      ),
      tierName: _localized(
        localeName,
        ar: tierNameAr,
        en: tierNameEn,
        fallback: tierName ?? tier,
      ),
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
      calories: (nutritionCalories ?? _wholeNumber(calories))?.toString() ?? '',
      protein: (nutritionProtein ?? _wholeNumber(proteinG))?.toString() ?? '',
      carbs: (nutritionCarbs ?? _wholeNumber(carbsG))?.toString() ?? '',
      fat: (nutritionFat ?? _wholeNumber(fatG))?.toString() ?? '',
      ingredients: ingredientItems,
      imageAsset: Assets.calendarMealPickerHero,
      actionLabel: '',
      proteinPercentage:
          (proteinPercentage ??
                  nutrition?.proteinPercentage ??
                  nutrition?.proteinPercent)
              ?.toDouble(),
      carbsPercentage:
          (carbsPercentage ??
                  nutrition?.carbsPercentage ??
                  nutrition?.carbsPercent)
              ?.toDouble(),
      fatPercentage:
          (fatPercentage ?? nutrition?.fatPercentage ?? nutrition?.fatPercent)
              ?.toDouble(),
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
      displayName: _firstNotEmpty([slotName, slotNameAr, slotNameEn, slot]),
      slotNameAr: slotNameAr ?? slotName ?? '',
      slotNameEn: slotNameEn ?? slotName ?? slotNameAr ?? '',
      count: count ?? 0,
    );
  }
}

extension CalendarAvailableMealSlotResponseDtoMapper
    on CalendarAvailableMealSlotResponseDto {
  CalendarSlotMealsEntity toEntity(
    String localeName,
    List<String> selectedIds,
  ) {
    return CalendarSlotMealsEntity(
      slot: slot ?? '',
      displayName: _firstNotEmpty([slotName, slotNameAr, slotNameEn, slot]),
      slotNameAr: slotNameAr ?? slotName ?? '',
      slotNameEn: slotNameEn ?? slotName ?? slotNameAr ?? '',
      count: count ?? 0,
      page: page ?? 1,
      pageSize: pageSize ?? 20,
      totalCount: totalCount ?? (meals?.length ?? 0),
      totalPages: totalPages ?? 1,
      hasNextPage: hasNextPage ?? false,
      hasPreviousPage: hasPreviousPage ?? false,
      meals: (meals ?? const [])
          .map((meal) => meal.toMealEntity(localeName, selectedIds))
          .where((meal) => meal.id.isNotEmpty)
          .toList(),
    );
  }
}

extension CalendarAvailableMealsResponseDtoMapper
    on CalendarAvailableMealsResponseDto {
  CalendarAvailableMealsEntity toEntity(String localeName) {
    final selectedIds = selectedMealIds ?? const [];
    final mappedSlots = (slots ?? const [])
        .map((slotDto) => slotDto.toEntity(localeName, selectedIds))
        .where((slot) => slot.slot.isNotEmpty)
        .toList();

    final allMealsFromSlots = mappedSlots.expand((slot) => slot.meals).toList();
    final topLevelMeals = (meals ?? const [])
        .map((meal) => meal.toMealEntity(localeName, selectedIds))
        .where((meal) => meal.id.isNotEmpty)
        .toList();

    final combinedMeals = topLevelMeals.isNotEmpty
        ? topLevelMeals
        : allMealsFromSlots;

    final mappedSlotRequirements =
        (slotRequirements != null && slotRequirements!.isNotEmpty)
        ? slotRequirements!
              .map((requirement) => requirement.toEntity())
              .where((r) => r.slot.isNotEmpty && r.count > 0)
              .toList()
        : mappedSlots
              .map(
                (s) => CalendarSlotRequirementEntity(
                  slot: s.slot,
                  displayName: s.displayName,
                  slotNameAr: s.slotNameAr,
                  slotNameEn: s.slotNameEn,
                  count: s.count,
                ),
              )
              .where((r) => r.slot.isNotEmpty && r.count > 0)
              .toList();

    return CalendarAvailableMealsEntity(
      restaurant:
          restaurant?.toRestaurantEntity(localeName) ??
          _flatRestaurantEntity(localeName),
      meals: combinedMeals,
      slotRequirements: mappedSlotRequirements,
      slots: mappedSlots,
      coreIngredients: (coreIngredients ?? const [])
          .map((ingredient) => ingredient.toEntity(localeName))
          .where((ingredient) => ingredient.name.isNotEmpty)
          .toList(),
      serviceDate: serviceDate,
      requiredCount: requiredCount,
      filledCount: filledCount,
    );
  }

  CalendarRestaurantEntity? _flatRestaurantEntity(String localeName) {
    if ((restaurantId == null || restaurantId!.isEmpty) &&
        (nameAr == null || nameAr!.isEmpty) &&
        (nameEn == null || nameEn!.isEmpty) &&
        (name == null || name!.isEmpty)) {
      return null;
    }

    final category = _localized(
      localeName,
      ar: programNameAr,
      en: programNameEn,
      fallback: programName,
    );
    final deliveryDuration = _localized(
      localeName,
      ar: tierNameAr,
      en: tierNameEn,
      fallback: tierName ?? tier,
    );
    final deliveryWindow = _deliveryWindowText(
      deliveryTimeText: deliveryTimeText,
      deliveryWindowStart: deliveryWindowStart,
      deliveryWindowEnd: deliveryWindowEnd,
    );

    return CalendarRestaurantEntity(
      id: restaurantId ?? '',
      logoUrl: _firstNullableNotEmpty([logoUrl, tierLogoUrl]),
      tierLogoUrl: tierLogoUrl ?? restaurant?.tierLogoUrl,
      ratingCount: ratingCount ?? restaurant?.ratingCount ?? 0,
      name: _localized(
        localeName,
        ar: nameAr,
        en: nameEn,
        fallback: name ?? nameEn ?? nameAr,
      ),
      category: category,
      rating: rating?.toString() ?? restaurant?.rating?.toString() ?? '4.5',
      deliveryDuration: deliveryDuration,
      deliveryWindow: deliveryWindow,
    );
  }
}

extension CalendarCoreIngredientResponseDtoMapper
    on CalendarCoreIngredientResponseDto {
  CalendarCoreIngredientEntity toEntity(String localeName) {
    return CalendarCoreIngredientEntity(
      id: id ?? '',
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      iconUrl: iconUrl,
      isLocal: isLocal ?? false,
      originCountryCode: originCountryCode ?? '',
      originCountryName: _localized(
        localeName,
        ar: originCountryNameAr,
        en: originCountryNameEn,
        fallback: originCountryName,
      ),
      flagEmoji: flagEmoji,
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
      uiStatus: day.uiStatus,
      isAutoSelected: day.isAutoSelected,
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
      lockRemainingSeconds: day.lockRemainingSeconds,
      filledCount: day.filledCount,
      requiredCount: day.requiredCount,
      failureReasonCode: day.failureReasonCode,
      restaurantRating: day.restaurantRating,
      restaurantRatingCount: day.restaurantRatingCount,
      deliveryWindowStart: day.deliveryWindowStart,
      deliveryWindowEnd: day.deliveryWindowEnd,
      deliveryTimeText: day.deliveryTimeText,
      tier: day.tier,
      tierNameAr: day.tierNameAr,
      tierNameEn: day.tierNameEn,
      tierName: day.tierName,
      tierLogoUrl: day.tierLogoUrl,
      programNameAr: day.programNameAr,
      programNameEn: day.programNameEn,
      programName: day.programName,
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
      proteinPercentage: (proteinPercentage ?? proteinPercent)?.toDouble(),
      carbsPercentage: (carbsPercentage ?? carbsPercent)?.toDouble(),
      fatPercentage: (fatPercentage ?? fatPercent)?.toDouble(),
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
    if (totals != null) {
      final totalsEntity = totals.toTotalsEntity();
      return CalendarNutritionTotalsEntity(
        calories: totalsEntity.calories,
        proteinG: totalsEntity.proteinG,
        carbsG: totalsEntity.carbsG,
        fatG: totalsEntity.fatG,
        proteinPercentage: (proteinPercentage ?? totalsEntity.proteinPercentage)
            ?.toDouble(),
        carbsPercentage: (carbsPercentage ?? totalsEntity.carbsPercentage)
            ?.toDouble(),
        fatPercentage: (fatPercentage ?? totalsEntity.fatPercentage)
            ?.toDouble(),
      );
    }

    final mealsForTotals = selectedMeals ?? _fallbackSelectedMealsForTotals();
    final summed = mealsForTotals.fold(
      const CalendarNutritionTotalsEntity(),
      (total, meal) => CalendarNutritionTotalsEntity(
        calories:
            total.calories +
            (_wholeNumber(meal.nutrition?.calories) ??
                _wholeNumber(meal.calories) ??
                0),
        proteinG:
            total.proteinG +
            (_wholeNumber(meal.nutrition?.proteinG) ??
                _wholeNumber(meal.proteinG) ??
                0),
        carbsG:
            total.carbsG +
            (_wholeNumber(meal.nutrition?.carbsG) ??
                _wholeNumber(meal.carbsG) ??
                0),
        fatG:
            total.fatG +
            (_wholeNumber(meal.nutrition?.fatG) ??
                _wholeNumber(meal.fatG) ??
                0),
      ),
    );

    final fatCal = summed.fatG * 9;
    final proteinCal = summed.proteinG * 4;
    final carbsCal = summed.carbsG * 4;
    final totalCal = fatCal + proteinCal + carbsCal;

    return CalendarNutritionTotalsEntity(
      calories: summed.calories,
      proteinG: summed.proteinG,
      carbsG: summed.carbsG,
      fatG: summed.fatG,
      proteinPercentage:
          (proteinPercentage ??
                  (totalCal > 0 ? (proteinCal / totalCal) * 100 : null))
              ?.toDouble(),
      carbsPercentage:
          (carbsPercentage ??
                  (totalCal > 0 ? (carbsCal / totalCal) * 100 : null))
              ?.toDouble(),
      fatPercentage:
          (fatPercentage ?? (totalCal > 0 ? (fatCal / totalCal) * 100 : null))
              ?.toDouble(),
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

String _deliveryWindowText({
  String? deliveryTimeText,
  String? deliveryWindowStart,
  String? deliveryWindowEnd,
}) {
  final providedText = _firstNullableNotEmpty([deliveryTimeText]);
  if (providedText != null) return providedText;

  final start = _firstNullableNotEmpty([deliveryWindowStart]);
  final end = _firstNullableNotEmpty([deliveryWindowEnd]);
  if (start == null && end == null) return '';
  if (start == null) return end!;
  if (end == null) return start;
  return '$start - $end';
}

String _formatWeekday(DateTime date, String localeName) {
  try {
    return DateFormat.E(localeName).format(date);
  } catch (_) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
