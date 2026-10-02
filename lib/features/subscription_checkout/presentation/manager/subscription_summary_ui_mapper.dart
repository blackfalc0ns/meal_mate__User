import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

extension SubscriptionSummaryUiMapper on SubscriptionSummaryEntity {
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
