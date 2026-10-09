part of 'calendar_mapper.dart';

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
      uiStatus: uiStatus,
      canEdit: canEdit,
      failureReasonCode: failureReasonCode,
      editBlockReason: editBlockReason ?? failureReasonCode,
      selectionDeadlineUtc: _parseDateTime(selectionDeadlineUtc),
      lockAtUtc: _parseDateTime(lockAtUtc ?? lockedAtUtc),
      lockRemainingSeconds: lockRemainingSeconds,
      filledCount: filledCount,
      requiredCount: requiredCount,
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
      isLocked: isLocked ?? (canEdit == false),
      editDeadlineUtc: _parseDateTime(
        selectionDeadlineUtc ?? editDeadlineUtc ?? lockAtUtc ?? lockedAtUtc,
      ),
      dayNumber: parsedDate?.day ?? 0,
      weekday: parsedDate == null ? '' : _formatWeekday(parsedDate, localeName),
      date: parsedDate,
      hasMeals:
          ((filledCount ?? 0) > 0) ||
          sortedDayMeals.isNotEmpty ||
          resolvedSelectedMealIds.isNotEmpty,
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
      rating: restaurantRating?.toString(),
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
        caloriesPercentage:
            (caloriesPercentage ?? totalsEntity.caloriesPercentage)?.toDouble(),
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
      caloriesPercentage: caloriesPercentage?.toDouble(),
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
      hasUnreadNotifications: hasUnreadNotifications,
      unreadNotificationsCount: unreadNotificationsCount,
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
