import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_plan_entity.dart';

class SubscriptionsFakeDataSource {
  const SubscriptionsFakeDataSource();

  static const String _mealsPerDay = '4 وجبات يومياً';
  static const String _description = 'وجبات صحية ومتوازنة';
  static const String _delivery = 'توصيل مجاني';
  static const String _discount = 'خصم 20%';

  List<SubscriptionProgramEntity> getPrograms() => const [
    SubscriptionProgramEntity(
      title: 'خسارة الوزن',
      description:
          'برنامج منخفض السعرات لمساعدتك على خسارة الوزن بطريقة صحية و آمنة',
      imageAsset: AssetsFake.subscriptionProgramWeightLoss,
      primaryFeature: 'نتائج فعالة',
      secondaryFeature: 'سعرات أقل',
      badgeIcon: Icons.monitor_weight_outlined,
      primaryFeatureIcon: Icons.bar_chart_rounded,
      secondaryFeatureIcon: Icons.bolt_rounded,
    ),
    SubscriptionProgramEntity(
      title: 'بناء العضلات',
      description:
          'برنامج عالي البروتين لدعم نمو العضلات وزيادة الكتلة العضلية',
      imageAsset: AssetsFake.subscriptionProgramMuscleGain,
      primaryFeature: 'بروتين عالي',
      secondaryFeature: 'تعافي أسرع',
      badgeIcon: Icons.fitness_center_rounded,
      primaryFeatureIcon: Icons.bolt_rounded,
      secondaryFeatureIcon: Icons.sync_rounded,
    ),
    SubscriptionProgramEntity(
      title: 'نظام صحي متوازن',
      description:
          'نظام متوازن غني بالعناصر الغذائية للحفاظ على صحتك ونشاطك اليومي',
      imageAsset: AssetsFake.subscriptionProgramBalanced,
      primaryFeature: 'تغذية متوازنة',
      secondaryFeature: 'طاقة يومية',
      badgeIcon: Icons.favorite_border_rounded,
      primaryFeatureIcon: Icons.eco_rounded,
      secondaryFeatureIcon: Icons.bolt_rounded,
    ),
    SubscriptionProgramEntity(
      title: 'تنشيف الجسم',
      description:
          'برنامج يساعدك على حرق الدهون وإبراز عضلاتك مع الحفاظ على الكتلة العضلية',
      imageAsset: AssetsFake.subscriptionProgramCutting,
      primaryFeature: 'حرق الدهون',
      secondaryFeature: 'تعريف الجسم',
      badgeIcon: Icons.local_fire_department_outlined,
      primaryFeatureIcon: Icons.bolt_rounded,
      secondaryFeatureIcon: Icons.my_location_rounded,
    ),
  ];

  List<SubscriptionPackageChoiceEntity> getPackageChoices() => const [
    SubscriptionPackageChoiceEntity(
      title: 'باقة 4 وجبات',
      subtitle: 'افطار - غداء - عشاء - سناك',
      isPopular: true,
      planDetailsIndex: 0,
    ),
    SubscriptionPackageChoiceEntity(
      title: 'باقة 3 وجبات',
      subtitle: '14 يوم ٠ 3 وجبات يومياً',
      planDetailsIndex: 1,
    ),
    SubscriptionPackageChoiceEntity(
      title: 'باقة وجبتين',
      subtitle: '7 يوم ٠ وجبتين يومياً',
      planDetailsIndex: 2,
    ),
    SubscriptionPackageChoiceEntity(
      title: 'الأسبوع',
      subtitle: '7 يوم ٠ وجبتين يومياً',
      price: '930',
      currency: 'KWD',
      planDetailsIndex: 2,
    ),
  ];

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
      imageAsset: AssetsFake.subscriptionMonthPlan,
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
      imageAsset: AssetsFake.subscriptionHeroMeal,
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
      imageAsset: AssetsFake.subscriptionWeekPlan,
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

class SubscriptionProgramEntity {
  const SubscriptionProgramEntity({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.primaryFeature,
    required this.secondaryFeature,
    required this.badgeIcon,
    required this.primaryFeatureIcon,
    required this.secondaryFeatureIcon,
  });

  final String title;
  final String description;
  final String imageAsset;
  final String primaryFeature;
  final String secondaryFeature;
  final IconData badgeIcon;
  final IconData primaryFeatureIcon;
  final IconData secondaryFeatureIcon;
}

class SubscriptionPackageChoiceEntity {
  const SubscriptionPackageChoiceEntity({
    required this.title,
    required this.subtitle,
    this.price,
    this.currency,
    this.isPopular = false,
    required this.planDetailsIndex,
  });

  final String title;
  final String subtitle;
  final String? price;
  final String? currency;
  final bool isPopular;
  final int planDetailsIndex;
}
