export 'subscription_flow_args.dart';

import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';

class SubscriptionReadinessEntity {

  const SubscriptionReadinessEntity({
    required this.isComplete,
    required this.canOpenSummary,
    required this.canCheckout,
    required this.nextAction,
    required this.warningAr,
    required this.warningEn,
    this.checkoutBlockReason,
    this.program,
    this.address,
    required this.deliveringRestaurantCount,
    required this.items,
    required this.restaurants,
  });

  final bool isComplete;
  final bool canOpenSummary;
  final bool canCheckout;
  final String nextAction;
  final String warningAr;
  final String warningEn;
  final String? checkoutBlockReason;
  final SubscriptionReadinessProgramEntity? program;
  final SubscriptionReadinessAddressEntity? address;
  final int deliveringRestaurantCount;
  final List<SubscriptionReadinessItemEntity> items;
  final List<SubscriptionReadinessRestaurantEntity> restaurants;

  String warning(String localeName) =>
      localeName == 'ar' ? warningAr : warningEn;

  bool get shouldOpenSummary =>
      canOpenSummary || nextAction.toUpperCase() == 'SUMMARY';

  bool get hasRestaurantCoverageBlock {
    final reason = checkoutBlockReason?.toLowerCase();

    return (!canCheckout && deliveringRestaurantCount == 0) ||
        reason == SubscriptionErrorCodes.restaurantNotEligible ||
        reason == SubscriptionErrorCodes.noRestaurantsForAddress ||
        reason == SubscriptionErrorCodes.checkoutNoRestaurantsForAddress;
  }

  List<SubscriptionReadinessItemEntity> get incompleteItems =>
      items.where((item) => !item.isComplete).toList();
}

class SubscriptionReadinessProgramEntity {
  const SubscriptionReadinessProgramEntity({
    required this.programId,
    required this.nameAr,
    required this.nameEn,
  });

  final String programId;
  final String nameAr;
  final String nameEn;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionReadinessAddressEntity {
  const SubscriptionReadinessAddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    this.governorate,
    this.area,
    this.block,
    this.regionId,
    this.governorateNameAr,
    this.governorateNameEn,
    this.areaNameAr,
    this.areaNameEn,
    this.blockNameAr,
    this.blockNameEn,
  });

  final String id;
  final String label;
  final String addressLine;
  final String? governorate;
  final String? area;
  final String? block;
  final String? regionId;
  final String? governorateNameAr;
  final String? governorateNameEn;
  final String? areaNameAr;
  final String? areaNameEn;
  final String? blockNameAr;
  final String? blockNameEn;

  String localizedNamesLine(String localeName) {
    final isAr = localeName == 'ar';

    final gov = isAr
        ? (governorateNameAr?.trim().isNotEmpty == true
            ? governorateNameAr!.trim()
            : (governorate?.trim() ?? ''))
        : (governorateNameEn?.trim().isNotEmpty == true
            ? governorateNameEn!.trim()
            : (governorate?.trim() ?? ''));

    final ar = isAr
        ? (areaNameAr?.trim().isNotEmpty == true
            ? areaNameAr!.trim()
            : (area?.trim() ?? ''))
        : (areaNameEn?.trim().isNotEmpty == true
            ? areaNameEn!.trim()
            : (area?.trim() ?? ''));

    final blk = isAr
        ? (blockNameAr?.trim().isNotEmpty == true
            ? blockNameAr!.trim()
            : (block?.trim() ?? ''))
        : (blockNameEn?.trim().isNotEmpty == true
            ? blockNameEn!.trim()
            : (block?.trim() ?? ''));

    return [gov, ar, blk].where((part) => part.isNotEmpty).join(' - ');
  }
}


class SubscriptionReadinessItemEntity {
  const SubscriptionReadinessItemEntity({
    required this.code,
    required this.isComplete,
    required this.titleAr,
    required this.titleEn,
    required this.actionScreen,
    this.endpoint,
  });

  final String code;
  final bool isComplete;
  final String titleAr;
  final String titleEn;
  final String actionScreen;
  final String? endpoint;

  String title(String localeName) => localeName == 'ar' ? titleAr : titleEn;
}

class SubscriptionReadinessRestaurantEntity {
  const SubscriptionReadinessRestaurantEntity({
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    this.logoUrl,
    required this.tier,
  });

  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final String tier;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}


