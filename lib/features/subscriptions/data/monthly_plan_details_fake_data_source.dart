import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanDetailsFakeDataSource {
  const MonthlyPlanDetailsFakeDataSource();

  MonthlyPlanDetailsEntity getPlanDetails() => getPlans().first;

  List<MonthlyPlanDetailsEntity> getPlans() {
    return const [
      MonthlyPlanDetailsEntity(
        titlePrefix: 'باقة',
        titleHighlight: 'الشهر',
        duration: '26 يوم',
        mealsPerDay: '3 وجبات يومياً',
        discountLabel: 'خصم 20% لفترة محدودة',
        subscribeLabel: 'اشترك الآن',
        price: '930',
        currency: 'KWD',
        heroImageAsset: AssetsFake.monthlyPackageBox,
        description:
            'باقة غذائية متكاملة تساعدك على خسارة الوزن بطريقة صحية وآمنة من خلال وجبات متوازنة و محسوبة السعرات بعناية',
        features: _features,
        packageTiers: _packageTiers,
        filters: _filters,
        restaurants: _restaurants,
        meals: _meals,
      ),
      MonthlyPlanDetailsEntity(
        titlePrefix: 'باقة',
        titleHighlight: 'الشهر',
        duration: '26 يوم',
        mealsPerDay: '3 وجبات يومياً',
        discountLabel: 'خصم 20% لفترة محدودة',
        subscribeLabel: 'اشترك الآن',
        price: '930',
        currency: 'KWD',
        heroImageAsset: AssetsFake.monthlyPackageBox,
        description:
            'باقة غذائية متكاملة تساعدك على خسارة الوزن بطريقة صحية وآمنة من خلال وجبات متوازنة و محسوبة السعرات بعناية',
        features: _features,
        packageTiers: _packageTiers,
        filters: _filters,
        restaurants: _restaurants,
        meals: _meals,
      ),
      MonthlyPlanDetailsEntity(
        titlePrefix: 'باقة',
        titleHighlight: 'الشهر',
        duration: '26 يوم',
        mealsPerDay: '3 وجبات يومياً',
        discountLabel: 'خصم 20% لفترة محدودة',
        subscribeLabel: 'اشترك الآن',
        price: '930',
        currency: 'KWD',
        heroImageAsset: AssetsFake.monthlyPackageBox,
        description:
            'باقة غذائية متكاملة تساعدك على خسارة الوزن بطريقة صحية وآمنة من خلال وجبات متوازنة و محسوبة السعرات بعناية',
        features: _features,
        packageTiers: _packageTiers,
        filters: _filters,
        restaurants: _restaurants,
        meals: _meals,
      ),
      MonthlyPlanDetailsEntity(
        titlePrefix: 'باقة',
        titleHighlight: 'الشهر',
        duration: '26 يوم',
        mealsPerDay: '3 وجبات يومياً',
        discountLabel: 'خصم 20% لفترة محدودة',
        subscribeLabel: 'اشترك الآن',
        price: '930',
        currency: 'KWD',
        heroImageAsset: AssetsFake.monthlyPackageBox,
        description:
            'باقة غذائية متكاملة تساعدك على خسارة الوزن بطريقة صحية وآمنة من خلال وجبات متوازنة و محسوبة السعرات بعناية',
        features: _features,
        packageTiers: _packageTiers,
        filters: _filters,
        restaurants: _restaurants,
        meals: _meals,
      ),
    ];
  }

  static const List<MonthlyPlanFilterEntity> _filters = [
    MonthlyPlanFilterEntity(label: 'الخطة', iconName: 'calendar'),
    MonthlyPlanFilterEntity(label: 'المطاعم', iconName: 'restaurant'),
    MonthlyPlanFilterEntity(label: 'الوجبات', iconName: 'meal'),
    MonthlyPlanFilterEntity(label: 'لمحة', iconName: 'overview'),
  ];

  static const List<MonthlyPlanFeatureEntity> _features = [
    MonthlyPlanFeatureEntity(
      title: 'وجبات صحية محسوبة السعرات',
      iconName: 'plant',
    ),
    MonthlyPlanFeatureEntity(title: 'خطة غذائية مخصصة لك', iconName: 'user'),
    MonthlyPlanFeatureEntity(
      title: 'إمكانية استبدال الوجبات',
      iconName: 'swap',
    ),
    MonthlyPlanFeatureEntity(
      title: 'دعم مباشر من أخصائي تغذية',
      iconName: 'support',
    ),
  ];

  static const List<MonthlyPackageTierEntity> _packageTiers = [
    MonthlyPackageTierEntity(
      title: 'بيزك',
      subtitle: 'أفضل المطاعم وتجربة فاخرة',
      price: '930',
      currency: 'KWD',
      period: 'شهرياً',
      iconName: 'leaf',
      bullets: ['جميع المطاعم متاحة', 'وجبات حصرية للشيف', 'أعلى جودة ومكونات'],
    ),
    MonthlyPackageTierEntity(
      title: 'ايليت',
      subtitle: 'أفضل المطاعم وتجربة فاخرة',
      price: '930',
      currency: 'KWD',
      period: 'شهرياً',
      iconName: 'star',
      isPopular: true,
      bullets: ['جميع المطاعم متاحة', 'وجبات حصرية للشيف', 'أعلى جودة ومكونات'],
    ),
    MonthlyPackageTierEntity(
      title: 'بلاتينيوم',
      subtitle: 'أفضل المطاعم وتجربة فاخرة',
      price: '930',
      currency: 'KWD',
      period: 'شهرياً',
      iconName: 'crown',
      bullets: ['جميع المطاعم متاحة', 'وجبات حصرية للشيف', 'أعلى جودة ومكونات'],
    ),
  ];

  static const List<MonthlyRestaurantPlanEntity> _restaurants = [
    MonthlyRestaurantPlanEntity(
      name: 'ماكدونالدز',
      subtitle: 'وجبات صحية متوازنة',
      meals: '22',
      rating: '4.6',
      logoAsset: AssetsFake.mcdonaldsLogo,
      brandColor: Color(0xFFFFCC00),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'ستاربكس',
      subtitle: 'وجبات صحية متوازنة',
      meals: '18',
      rating: '4.7',
      logoAsset: AssetsFake.starbucksLogo,
      brandColor: Color(0xFF00623D),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'دايت هاوس',
      subtitle: 'وجبات صحية متوازنة',
      meals: '28',
      rating: '4.8',
      initials: 'DIET\nHOUSE',
      brandColor: Color(0xFF28791F),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'برجر كينج',
      subtitle: 'وجبات صحية متوازنة',
      meals: '16',
      rating: '4.5',
      logoAsset: AssetsFake.burgerKingLogo,
      brandColor: Color(0xFFCC2417),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'هيلثي بول',
      subtitle: 'وجبات صحية متوازنة',
      meals: '26',
      rating: '4.8',
      initials: 'HEALTHY\nBOWL',
      brandColor: Color(0xFF28791F),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'أوفن ستوري',
      subtitle: 'وجبات صحية متوازنة',
      meals: '14',
      rating: '4.4',
      initials: 'OVEN\nSTORY',
      brandColor: Color(0xFFCC2417),
    ),
    MonthlyRestaurantPlanEntity(
      name: 'بروتين كيتشن',
      subtitle: 'وجبات صحية متوازنة',
      meals: '28',
      rating: '4.8',
      initials: 'THE\nPROTEIN\nKITCHEN',
      brandColor: Color(0xFF111111),
    ),
  ];

  static const List<MonthlyMealEntity> _meals = [
    MonthlyMealEntity(
      name: 'لحم بقري مشوي',
      subtitle: 'مع بطاطا حارة',
      calories: '560 سعرة',
      protein: '35g بروتين',
      imageAsset: AssetsFake.grilledPlate,
    ),
    MonthlyMealEntity(
      name: 'مكرونة بالصلصة',
      subtitle: 'مع بطاطا حارة',
      calories: '560 سعرة',
      protein: '35g بروتين',
      imageAsset: AssetsFake.mealBoxes,
    ),
    MonthlyMealEntity(
      name: 'سالمون مشوي',
      subtitle: 'مع بطاطا حارة',
      calories: '560 سعرة',
      protein: '35g بروتين',
      imageAsset: AssetsFake.saladBowl,
    ),
    MonthlyMealEntity(
      name: 'دجاج مشوي',
      subtitle: 'مع بطاطا حارة',
      calories: '560 سعرة',
      protein: '35g بروتين',
      imageAsset: AssetsFake.grilledPlate,
    ),
  ];
}
