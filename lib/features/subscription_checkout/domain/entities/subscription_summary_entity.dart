import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_coupon_entity.dart';

class SubscriptionSummaryEntity {

  const SubscriptionSummaryEntity({
    required this.programId,
    required this.programNameAr,
    required this.programNameEn,
    this.programImageUrl,
    required this.bundleId,
    required this.bundleNameAr,
    required this.bundleNameEn,
    this.imageUrl,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    required this.restaurantCount,
    required this.tier,
    required this.tierNameAr,
    required this.tierNameEn,
    required this.durationDays,
    required this.chosenStartDate,
    required this.startDate,
    required this.endDate,
    required this.serviceDates,
    this.restaurantRepetition,
    required this.slotRequirements,
    required this.basePrice,
    required this.campaignDiscount,
    required this.promoDiscount,
    required this.walletCredit,
    required this.gatewayFee,
    required this.finalPrice,
    required this.currencyCode,
    required this.canCheckout,
    this.checkoutBlockReason,
    this.address,
    required this.restaurants,
    required this.termsAcceptanceRequired,
    required this.checkoutEndpoint,
    required this.includeFriday,
    required this.fridayDays,
    required this.totalServiceDays,
    required this.includes,
    this.coupon,
    this.restaurantsPagination,
  });

  final String programId;
  final String programNameAr;
  final String programNameEn;
  final String? programImageUrl;
  final String bundleId;
  final String bundleNameAr;
  final String bundleNameEn;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int restaurantCount;
  final String tier;
  final String tierNameAr;
  final String tierNameEn;
  final int durationDays;
  final String chosenStartDate;
  final String startDate;
  final String endDate;
  final List<String> serviceDates;
  final SubscriptionSummaryRestaurantRepetitionEntity? restaurantRepetition;
  final List<SubscriptionSummarySlotRequirementEntity> slotRequirements;
  final double basePrice;
  final double campaignDiscount;
  final double promoDiscount;
  final double walletCredit;
  final double gatewayFee;
  final double finalPrice;
  final String currencyCode;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final SubscriptionSummaryAddressEntity? address;
  final List<SubscriptionSummaryRestaurantEntity> restaurants;
  final bool termsAcceptanceRequired;
  final String checkoutEndpoint;
  final bool includeFriday;
  final int fridayDays;
  final int totalServiceDays;
  final SubscriptionSummaryIncludesEntity includes;
  final SubscriptionCouponEntity? coupon;
  final PaginationEntity? restaurantsPagination;

  String programName(String localeName) =>
      localeName == 'ar' ? programNameAr : programNameEn;

  String bundleName(String localeName) =>
      localeName == 'ar' ? bundleNameAr : bundleNameEn;

  String tierName(String localeName) {
    final localizedName = localeName == 'ar' ? tierNameAr : tierNameEn;
    return localizedName.trim().isEmpty ? tier : localizedName;
  }

  String? restaurantName(String localeName) =>
      localeName == 'ar' ? restaurantNameAr : restaurantNameEn;

  String? get firstRestaurantId {
    if (restaurantId != null && restaurantId!.isNotEmpty) {
      return restaurantId;
    }
    for (final restaurant in restaurants) {
      if (restaurant.restaurantId.isNotEmpty) return restaurant.restaurantId;
    }
    return null;
  }

  SubscriptionSummaryEntity copyWithRestaurants({
    required List<SubscriptionSummaryRestaurantEntity> restaurants,
    PaginationEntity? restaurantsPagination,
  }) {
    return SubscriptionSummaryEntity(
      programId: programId,
      programNameAr: programNameAr,
      programNameEn: programNameEn,
      programImageUrl: programImageUrl,
      bundleId: bundleId,
      bundleNameAr: bundleNameAr,
      bundleNameEn: bundleNameEn,
      imageUrl: imageUrl,
      restaurantId: restaurantId,
      restaurantNameAr: restaurantNameAr,
      restaurantNameEn: restaurantNameEn,
      restaurantCount: restaurantCount,
      tier: tier,
      tierNameAr: tierNameAr,
      tierNameEn: tierNameEn,
      durationDays: durationDays,
      chosenStartDate: chosenStartDate,
      startDate: startDate,
      endDate: endDate,
      serviceDates: serviceDates,
      restaurantRepetition: restaurantRepetition,
      slotRequirements: slotRequirements,
      basePrice: basePrice,
      campaignDiscount: campaignDiscount,
      promoDiscount: promoDiscount,
      walletCredit: walletCredit,
      gatewayFee: gatewayFee,
      finalPrice: finalPrice,
      currencyCode: currencyCode,
      canCheckout: canCheckout,
      checkoutBlockReason: checkoutBlockReason,
      address: address,
      restaurants: restaurants,
      termsAcceptanceRequired: termsAcceptanceRequired,
      checkoutEndpoint: checkoutEndpoint,
      includeFriday: includeFriday,
      fridayDays: fridayDays,
      totalServiceDays: totalServiceDays,
      includes: includes,
      coupon: coupon,
      restaurantsPagination:
          restaurantsPagination ?? this.restaurantsPagination,
    );
  }
}


class SubscriptionSummaryRestaurantRepetitionEntity {
  const SubscriptionSummaryRestaurantRepetitionEntity({
    required this.limit,
    required this.restaurantCount,
    required this.durationDays,
  });

  final int limit;
  final int restaurantCount;
  final int durationDays;
}

class SubscriptionSummaryAddressEntity {
  const SubscriptionSummaryAddressEntity({
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

  String get formattedAddress {
    if (addressLine.trim().isNotEmpty) {
      return addressLine.trim();
    }
    return [
      governorate,
      area,
      block,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' - ');
  }
}



class SubscriptionSummaryRestaurantEntity {
  const SubscriptionSummaryRestaurantEntity({
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

class SubscriptionSummarySlotRequirementEntity {
  const SubscriptionSummarySlotRequirementEntity({
    required this.slot,
    required this.nameAr,
    required this.nameEn,
    required this.count,
  });

  final String slot;
  final String nameAr;
  final String nameEn;
  final int count;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionSummaryIncludesEntity {
  const SubscriptionSummaryIncludesEntity({
    required this.titleAr,
    required this.titleEn,
    required this.items,
  });

  final String titleAr;
  final String titleEn;
  final List<SubscriptionSummaryIncludeItemEntity> items;

  String title(String localeName) => localeName == 'ar' ? titleAr : titleEn;
}

class SubscriptionSummaryIncludeItemEntity {
  const SubscriptionSummaryIncludeItemEntity({
    required this.code,
    required this.textAr,
    required this.textEn,
  });

  final String code;
  final String textAr;
  final String textEn;

  String text(String localeName) => localeName == 'ar' ? textAr : textEn;
}
