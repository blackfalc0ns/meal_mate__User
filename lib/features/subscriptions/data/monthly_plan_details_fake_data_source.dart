import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanDetailsFakeDataSource {
  const MonthlyPlanDetailsFakeDataSource();

  MonthlyPlanDetailsEntity getPlanDetails() {
    return const MonthlyPlanDetailsEntity(
      titlePrefix: 'باقة',
      titleHighlight: 'الشهر',
      duration: '26 يوم',
      mealsPerDay: '3 وجبات يومياً',
      discountLabel: 'خصم 20% لفترة محدودة',
      subscribeLabel: 'اشترك الآن',
      price: '930',
      currency: 'KWD',
      filters: [
        MonthlyPlanFilterEntity(label: 'الخطة', iconName: 'calendar'),
        MonthlyPlanFilterEntity(label: 'المطاعم', iconName: 'restaurant'),
        MonthlyPlanFilterEntity(label: 'الوجبات', iconName: 'meal'),
        MonthlyPlanFilterEntity(label: 'لمحة', iconName: 'overview'),
      ],
      restaurants: [
        MonthlyRestaurantPlanEntity(
          name: 'ستاربكس',
          subtitle: 'وجبات صحية متوازنة',
          meals: '18',
          rating: '4.7',
          logoAsset: Assets.offerStarbucksLogo,
          brandColor: Color(0xFF00623D),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'ماكدونالدز',
          subtitle: 'وجبات صحية متوازنة',
          meals: '22',
          rating: '4.6',
          logoAsset: Assets.offerMcdonaldsLogo,
          brandColor: Color(0xFFFFCC00),
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
          logoAsset: Assets.offerBurgerKingLogo,
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
          name: 'سلاد ستيشن',
          subtitle: 'وجبات صحية متوازنة',
          meals: '20',
          rating: '4.8',
          initials: 'SALAD\nSTATION',
          brandColor: Color(0xFF009242),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'بروتين كيتشن',
          subtitle: 'وجبات صحية متوازنة',
          meals: '24',
          rating: '4.7',
          initials: 'THE\nPROTEIN',
          brandColor: Color(0xFF111111),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'ماما نورة',
          subtitle: 'وجبات صحية متوازنة',
          meals: '28',
          rating: '4.8',
          initials: 'mama\nnoura',
          brandColor: Color(0xFFCC2417),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'جرين بايتس',
          subtitle: 'اختيارات خفيفة وغنية',
          meals: '19',
          rating: '4.6',
          initials: 'GREEN\nBITES',
          brandColor: Color(0xFF04994E),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'فيت كافيه',
          subtitle: 'وجبات بروتين يومية',
          meals: '21',
          rating: '4.5',
          initials: 'FIT\nCAFE',
          brandColor: Color(0xFF0C6C3F),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'باستا لايت',
          subtitle: 'أطباق محسوبة السعرات',
          meals: '17',
          rating: '4.3',
          initials: 'PASTA\nLIGHT',
          brandColor: Color(0xFFEABC67),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'فريش بوكس',
          subtitle: 'صناديق صحية جاهزة',
          meals: '25',
          rating: '4.9',
          initials: 'FRESH\nBOX',
          brandColor: Color(0xFF04A356),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'كيتو كورنر',
          subtitle: 'وجبات قليلة الكربوهيدرات',
          meals: '15',
          rating: '4.4',
          initials: 'KETO\nCORNER',
          brandColor: Color(0xFF7643BB),
        ),
        MonthlyRestaurantPlanEntity(
          name: 'سناك هاوس',
          subtitle: 'سناكات مشبعة وخفيفة',
          meals: '12',
          rating: '4.2',
          initials: 'SNACK\nHOUSE',
          brandColor: Color(0xFFFE6713),
        ),
      ],
    );
  }
}
