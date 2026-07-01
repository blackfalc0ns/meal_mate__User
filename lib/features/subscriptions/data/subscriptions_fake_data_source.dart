import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/subscription_plan_entity.dart';

class SubscriptionsFakeDataSource {
  const SubscriptionsFakeDataSource();

  static const String _mealsPerDay = '4 وجبات يومياً';
  static const String _description = 'وجبات صحية ومتوازنة';
  static const String _delivery = 'توصيل مجاني';
  static const String _discount = 'خصم 20%';

  List<SubscriptionPlanEntity> getPlans() => [
    SubscriptionPlanEntity(
      title: 'باقة شهر',
      duration: '26 أيام',
      mealsPerDay: _mealsPerDay,
      description: _description,
      delivery: _delivery,
      periodLabel: 'شهرياً',
      originalPrice: '52.000',
      discountedPrice: '41.600',
      discountLabel: _discount,
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
      title: 'باقة نصف شهر',
      duration: '12 أيام',
      mealsPerDay: _mealsPerDay,
      description: _description,
      delivery: _delivery,
      periodLabel: 'نصف شهر',
      originalPrice: '26.000',
      discountedPrice: '20.600',
      discountLabel: _discount,
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
      title: 'باقة أسبوع',
      duration: '7 أيام',
      mealsPerDay: _mealsPerDay,
      description: _description,
      delivery: _delivery,
      periodLabel: 'أسبوعياً',
      originalPrice: '14.000',
      discountedPrice: '11.600',
      discountLabel: _discount,
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
