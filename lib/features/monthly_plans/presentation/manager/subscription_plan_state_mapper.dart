import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

extension SubscriptionPlanStateMapper on SubscriptionPlanState {
  MonthlyPlanDetailsEntity toPlanDetails({
    required SubscriptionProgramEntity program,
    required SubscriptionBundleEntity bundle,
    required String localeName,
    String? titlePrefix,
    required String dayLabel,
    required String subscribeLabel,
    required Color primaryColor,
  }) {
    final duration = selectedDuration;
    final selected = selectedTier;

    return MonthlyPlanDetailsEntity(
      titlePrefix: titlePrefix ?? program.name(localeName),
      titleHighlight: bundle.name(localeName),
      duration: duration == null
          ? ''
          : selectedDurationDays == null
          ? duration.name(localeName)
          : '$selectedDurationDays $dayLabel',
      mealsPerDay: bundle.description(localeName),
      discountLabel: selected?.name(localeName) ?? '',
      subscribeLabel: subscribeLabel,
      price: selected?.totalPrice != null
          ? selected!.totalPrice!.formattedPrice
          : (selected?.dailyPrice != null
                ? selected!.dailyPrice!.formattedPrice
                : ''),
      currency: (selected?.currencyCode.isNotEmpty ?? false)
          ? (selected!.currencyCode == 'KWD'
                ? (localeName == 'ar' ? 'د.ك' : 'KWD')
                : selected.currencyCode)
          : (localeName == 'ar' ? 'د.ك' : 'KWD'),
      heroImageAsset: Assets.monthlyPlanHero,
      description: program.description(localeName),
      features: const [],
      packageTiers: tiers
          .map((tier) => tier.toPackageTier(localeName))
          .toList(),
      filters: const [],
      restaurants: browseRestaurants
          .map(
            (restaurant) => restaurant.toRestaurantPlan(
              programId: program.programId,
              bundleId: bundle.bundleId,
              localeName: localeName,
              brandColor: primaryColor,
            ),
          )
          .toList(),
      meals: const [],
    );
  }

  SubscriptionSummaryRequestEntity? toSummaryRequest({
    required String programId,
    required String bundleId,
  }) {
    final days = selectedDurationDays;
    final selected = selectedTier;
    if (days == null || selected == null) return null;

    return SubscriptionSummaryRequestEntity(
      includeFriday: includeFriday,
      durationDays: days,
      tier: selected.tier,
      bundleId: bundleId,
      programId: programId,
      startDate: selectedStartDate ?? '',
    );
  }
}

extension SubscriptionSummaryRestaurantBrowseMapper
    on SubscriptionSummaryRestaurantEntity {
  SubscriptionTierRestaurantBrowseEntity toBrowseEntity() {
    return SubscriptionTierRestaurantBrowseEntity(
      restaurantId: restaurantId,
      nameAr: nameAr,
      nameEn: nameEn,
      nameRaw: '',
      logoUrl: logoUrl,
      rating: null,
      mealCount: 0,
      bundleMealCount: 0,
      tier: tier,
      tierNameAr: '',
      tierNameEn: '',
      tierLogoUrl: null,
      classifications: const [],
    );
  }
}
