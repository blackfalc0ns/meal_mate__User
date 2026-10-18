import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';

class SubscriptionBundleEntity {
  const SubscriptionBundleEntity({
    required this.bundleId,
    required this.programId,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageUrl,
    required this.mealsPerDay,
    required this.breakfastCount,
    required this.lunchCount,
    required this.dinnerCount,
    required this.snackCount,
    required this.slots,
    required this.restaurantCount,
    required this.restaurants,
    required this.selectionCount,
    required this.isMostSelected,
    required this.badge,
    this.availability,
  });

  final String bundleId;
  final String programId;
  final String code;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? imageUrl;
  final int mealsPerDay;
  final int breakfastCount;
  final int lunchCount;
  final int dinnerCount;
  final int snackCount;
  final List<SubscriptionBundleSlotEntity> slots;
  final int restaurantCount;
  final List<SubscriptionBundleRestaurantEntity> restaurants;
  final int selectionCount;
  final bool isMostSelected;
  final SubscriptionBundleBadgeEntity? badge;
  final SubscriptionAvailabilityEntity? availability;

  bool get canSelect =>
      availability?.effectiveCanSelect ?? (availability?.canSelect ?? true);

  String? get disabledReason =>
      availability?.messageCode.isNotEmpty == true
          ? availability!.messageCode
          : (availability?.failureReasons.isNotEmpty == true
              ? availability!.failureReasons.first
              : null);

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;

  String description(String localeName) =>
      localeName == 'ar' ? descriptionAr : descriptionEn;
}

class SubscriptionProgramBundlesEntity {
  const SubscriptionProgramBundlesEntity({
    required this.hasDeliveryAddress,
    required this.hasAllergies,
    required this.hasDietaryPreferences,
    required this.isProfileComplete,
    required this.bundles,
  });

  final bool hasDeliveryAddress;
  final bool hasAllergies;
  final bool hasDietaryPreferences;
  final bool isProfileComplete;
  final List<SubscriptionBundleEntity> bundles;
}

class SubscriptionBundleSlotEntity {
  const SubscriptionBundleSlotEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.quantity,
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final int quantity;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionBundleRestaurantEntity {
  const SubscriptionBundleRestaurantEntity({
    required this.restaurantId,
    required this.logoUrl,
  });

  final String restaurantId;
  final String? logoUrl;
}

class SubscriptionBundleBadgeEntity {
  const SubscriptionBundleBadgeEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String code;
  final String nameAr;
  final String nameEn;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}
