import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/subscription_plan_entity.dart';

class SubscriptionsFakeDataSource {
  const SubscriptionsFakeDataSource();

  List<SubscriptionPlanEntity> getPlans(AppLocalizations l10n) => [
    SubscriptionPlanEntity(
      title: l10n.subscription_month_plan_title,
      duration: l10n.subscription_month_duration,
      mealsPerDay: l10n.subscription_meals_per_day,
      description: l10n.subscription_healthy_balanced,
      delivery: l10n.subscription_free_delivery,
      periodLabel: l10n.subscription_month_period,
      originalPrice: '52.000',
      discountedPrice: '41.600',
      discountLabel: l10n.subscription_discount_20,
      imageAsset: Assets.subscriptionMonthPlan,
      accentColor: const Color(0xFF418B46),
      badgeBackgroundColor: const Color(0xFFDFE9DA),
      gradientColors: const [
        Color(0xFFE9F3E8),
        Color(0xFFFAF8FE),
        Colors.white,
      ],
    ),
    SubscriptionPlanEntity(
      title: l10n.subscription_half_month_plan_title,
      duration: l10n.subscription_half_month_duration,
      mealsPerDay: l10n.subscription_meals_per_day,
      description: l10n.subscription_healthy_balanced,
      delivery: l10n.subscription_free_delivery,
      periodLabel: l10n.subscription_half_month_period,
      originalPrice: '26.000',
      discountedPrice: '20.600',
      discountLabel: l10n.subscription_discount_20,
      imageAsset: Assets.subscriptionHalfMonthPlan,
      accentColor: const Color(0xFFEABC67),
      badgeBackgroundColor: const Color(0xFFFEF2E2),
      gradientColors: const [
        Color(0xFFFDF7EB),
        Color(0xFFFAF8FE),
        Colors.white,
      ],
    ),
    SubscriptionPlanEntity(
      title: l10n.subscription_week_plan_title,
      duration: l10n.subscription_week_duration,
      mealsPerDay: l10n.subscription_meals_per_day,
      description: l10n.subscription_healthy_balanced,
      delivery: l10n.subscription_free_delivery,
      periodLabel: l10n.subscription_week_period,
      originalPrice: '14.000',
      discountedPrice: '11.600',
      discountLabel: l10n.subscription_discount_20,
      imageAsset: Assets.subscriptionWeekPlan,
      accentColor: const Color(0xFFA373C0),
      badgeBackgroundColor: const Color(0xFFECE6F2),
      gradientColors: const [
        Color(0xFFF4F1FC),
        Color(0xFFFAF8FE),
        Colors.white,
      ],
    ),
  ];
}
