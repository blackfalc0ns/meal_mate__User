import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

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

  MonthlyPlanDetailsEntity toPlanDetails({
    required String localeName,
    required String dayLabel,
    required Color primaryColor,
    required MonthlyPlanDetailsEntity initialPlan,
  }) {
    final includesList = includes.items
        .map((i) => i.text(localeName).trim())
        .where((text) => text.isNotEmpty)
        .toList();

    return MonthlyPlanDetailsEntity(
      titlePrefix: programName(localeName).isNotEmpty
          ? programName(localeName)
          : initialPlan.titlePrefix,
      titleHighlight: bundleName(localeName).isNotEmpty
          ? bundleName(localeName)
          : initialPlan.titleHighlight,
      duration: '$durationDays $dayLabel',
      mealsPerDay: slotRequirements.isNotEmpty
          ? slotRequirements
                .where((r) => r.count > 0)
                .map((r) => '${r.count} ${r.name(localeName)}')
                .join(' + ')
          : initialPlan.mealsPerDay,
      discountLabel: tierName(localeName),
      subscribeLabel: initialPlan.subscribeLabel,
      price: finalPrice.formattedPrice,
      currency: currencyCode,
      heroImageAsset: initialPlan.heroImageAsset,
      description: initialPlan.description,
      features: includesList.isNotEmpty
          ? includesList
                .map(
                  (text) =>
                      MonthlyPlanFeatureEntity(title: text, iconName: 'check'),
                )
                .toList()
          : initialPlan.features,
      packageTiers: [
        MonthlyPackageTierEntity(
          title: bundleName(localeName),
          subtitle: programName(localeName),
          price: finalPrice.formattedPrice,
          currency: currencyCode,
          period: '$durationDays $dayLabel',
          bullets: includesList,
          iconName: tier.toLowerCase(),
          logoUrl: null,
          restaurantCount: restaurantCount,
          restaurantLogoUrls: restaurants
              .map((r) => r.logoUrl)
              .whereType<String>()
              .toList(),
        ),
      ],
      filters: initialPlan.filters,
      restaurants: restaurants
          .map(
            (restaurant) => MonthlyRestaurantPlanEntity(
              programId: programId,
              bundleId: bundleId,
              restaurantId: restaurant.restaurantId,
              name: restaurant.name(localeName),
              subtitle: restaurant.tier,
              meals: '',
              bundleMeals: '',
              rating: '',
              brandColor: primaryColor,
              classificationLogoUrls: const [],
              logoUrl: restaurant.logoUrl,
            ),
          )
          .toList(),
      meals: initialPlan.meals,
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
  });

  final String id;
  final String label;
  final String addressLine;
  final String? governorate;
  final String? area;
  final String? block;
  final String? regionId;

  String get formattedAddress => [
    addressLine,
    governorate,
    area,
    block,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' - ');
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
