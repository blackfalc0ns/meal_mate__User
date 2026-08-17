import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';

class RestaurantTierUpgradeFakeDataSource {
  const RestaurantTierUpgradeFakeDataSource();

  RestaurantTierUpgradeEntity getUpgrade() {
    return const RestaurantTierUpgradeEntity(
      title: 'ترقية تصنيف المطاعم',
      packagePrefix: 'باقة',
      mealsCount: '4',
      mealsSuffix: 'وجبات',
      remainingPrefix: 'متبقي',
      remainingDays: '18',
      remainingSuffix: 'يوم',
      activeLabel: 'نشط',
      currentLabel: 'التصنيف الحالي:',
      currentTierName: 'سيليكت',
      note: 'يمكنك ترقية التصنيف حتى نهاية مدة الاشتراك الحالية.',
      chooseTitle: 'اختر التصنيف الذي تريد الترقية إليه',
      chooseSubtitle: 'كلما ارتفع التصنيف، كلما شملت خيارات مطاعم أكثر وأفضل.',
      price: '6.500د.ك',
      pricePeriod: 'حتى نهاية الاشتراك',
      continuePlusLabel: 'متابعة الترقية إلى بلس',
      continueMaxLabel: 'متابعة الترقية إلى ماكس',
      tiers: [
        RestaurantTierOptionEntity(
          name: 'سيليكت',
          description: 'كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.',
          restaurantCount: '+25',
          buttonLabel: 'تصنيفك الحالي',
          badgeAsset: Assets.restaurantTierSelect,
          type: RestaurantTierOptionType.current,
        ),
        RestaurantTierOptionEntity(
          name: 'بلس',
          description: 'يشمل كل مطاعم سيلكت مطاعم إضافية',
          restaurantCount: '+50',
          buttonLabel: 'ترقية إلى بلس',
          badgeAsset: Assets.restaurantTierPlus,
          type: RestaurantTierOptionType.plus,
        ),
        RestaurantTierOptionEntity(
          name: 'ماكس',
          description: 'يشمل كل مطاعم سيلكت مطاعم إضافية',
          restaurantCount: '+100',
          buttonLabel: 'ترقية إلى ماكس',
          badgeAsset: Assets.restaurantTierMax,
          type: RestaurantTierOptionType.max,
        ),
      ],
    );
  }
}
