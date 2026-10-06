part of 'calendar_mapper.dart';

extension CalendarRestaurantResponseDtoMapper on CalendarRestaurantResponseDto {
  CalendarRestaurantEntity toRestaurantEntity(String localeName) {
    return CalendarRestaurantEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      imageUrl: imageUrl,
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
      rating: rating?.toString(),
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
      rating: rating?.toString(),
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
