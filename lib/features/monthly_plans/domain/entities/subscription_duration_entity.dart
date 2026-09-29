import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_item.dart';

class SubscriptionDurationEntity implements SubscriptionDurationItem {
  const SubscriptionDurationEntity({
    required this.durationDays,
    required this.nameAr,
    required this.nameEn,
    required this.selectionCount,
    required this.isPopular,
    required this.isCustom,
    required this.minDays,
    required this.maxDays,
    required this.badge,
    required this.supportsFriday,
    required this.includeFriday,
    required this.fridayDays,
    required this.totalServiceDays,
    required this.fridayOption,
    required this.fridayAvailability,
  });

  @override
  final int? durationDays;
  final String nameAr;
  final String nameEn;
  final int selectionCount;
  final bool isPopular;
  @override
  final bool isCustom;
  @override
  final int? minDays;
  @override
  final int? maxDays;
  final SubscriptionPlanBadgeEntity? badge;
  final bool supportsFriday;
  final bool includeFriday;
  final int fridayDays;
  @override
  final int totalServiceDays;
  final SubscriptionFridayOptionEntity fridayOption;
  final SubscriptionFridayAvailabilityEntity fridayAvailability;

  @override
  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionPlanBadgeEntity {
  const SubscriptionPlanBadgeEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String code;
  final String nameAr;
  final String nameEn;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionFridayOptionEntity {
  const SubscriptionFridayOptionEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.defaultSelected,
    required this.isEnabled,
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final bool defaultSelected;
  final bool isEnabled;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionFridayAvailabilityEntity {
  const SubscriptionFridayAvailabilityEntity({
    required this.isAvailable,
    required this.restaurantCount,
    required this.code,
    required this.messageAr,
    required this.messageEn,
    required this.displayType,
  });

  final bool isAvailable;
  final int restaurantCount;
  final String code;
  final String messageAr;
  final String messageEn;
  final String displayType;

  String message(String localeName) =>
      localeName == 'ar' ? messageAr : messageEn;
}
