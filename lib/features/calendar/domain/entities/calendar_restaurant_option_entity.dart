class CalendarRestaurantOptionEntity {
  const CalendarRestaurantOptionEntity({
    this.id = '',
    this.logoUrl,
    this.maxUsageCount,
    this.usedCount,
    this.remainingCount,
    this.isBusy = false,
    this.isQuotaExhausted = false,
    this.isEnabled = true,
    this.disabledReason,
    this.isUsageLimitReached = false,
    required this.name,
    required this.description,
    required this.mealCount,
    required this.rating,
    required this.logoType,
  });

  final String id;
  final String? logoUrl;
  final int? maxUsageCount;
  final int? usedCount;
  final int? remainingCount;
  final bool isBusy;
  final bool isQuotaExhausted;
  final bool isEnabled;
  final String? disabledReason;
  final bool isUsageLimitReached;
  final String name;
  final String description;
  final int mealCount;
  final String rating;
  final CalendarRestaurantLogoType logoType;
}

enum CalendarRestaurantLogoType {
  healthyBowl,
  dietHouse,
  proteinKitchen,
  starbucks,
  burgerKing,
}
