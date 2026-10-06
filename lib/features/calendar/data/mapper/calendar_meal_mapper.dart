part of 'calendar_mapper.dart';

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
      allergens: _mealAllergens(this, localeName),
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

List<CalendarMealAllergenEntity> _mealAllergens(
  CalendarMealResponseDto meal,
  String localeName,
) {
  final details = meal.allergenDetails ?? const [];
  if (details.isNotEmpty) {
    return details
        .map(
          (allergen) => CalendarMealAllergenEntity(
            code: allergen.code ?? '',
            label: _localized(
              localeName,
              ar: allergen.nameAr,
              en: allergen.nameEn,
              fallback: allergen.name,
            ),
          ),
        )
        .where((allergen) => allergen.label.isNotEmpty)
        .toList();
  }

  final labels = _localizedList(
    localeName,
    ar: meal.allergensAr,
    en: meal.allergensEn,
    fallback: meal.allergens,
  );

  return [
    for (var index = 0; index < labels.length; index++)
      CalendarMealAllergenEntity(
        code: index < (meal.presentAllergenCodes?.length ?? 0)
            ? meal.presentAllergenCodes![index]
            : '',
        label: labels[index],
      ),
  ];
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
      rating: rating?.toString() ?? restaurant?.rating?.toString(),
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
      caloriesPercentage: caloriesPercentage?.toDouble(),
    );
  }
}
