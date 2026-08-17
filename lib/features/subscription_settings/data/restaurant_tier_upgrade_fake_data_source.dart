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
      currentTierName: 'سيلكت',
      note: 'يمكنك ترقية التصنيف حتى نهاية مدة الاشتراك الحالية.',
      chooseTitle: 'اختر التصنيف الذي تريد الترقية إليه',
      chooseSubtitle: 'كلما ارتفع التصنيف، كلما شملت خيارات مطاعم أكثر وأفضل.',
      price: '6.500 د.ك',
      pricePeriod: 'حتى نهاية الاشتراك',
      continuePlusLabel: 'متابعة الترقية إلى بلس',
      continueMaxLabel: 'متابعة الترقية إلى ماكس',
      tiers: [
        RestaurantTierOptionEntity(
          name: 'سيلكت',
          description: 'كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.',
          restaurantCount: '+25',
          buttonLabel: 'تصنيفك الحالي',
          badgeAsset: Assets.restaurantTierSelect,
          type: RestaurantTierOptionType.current,
        ),
        RestaurantTierOptionEntity(
          name: 'بلس',
          description: 'يشمل كل مطاعم سيلكت + مطاعم إضافية',
          restaurantCount: '+50',
          buttonLabel: 'ترقية إلى بلس',
          badgeAsset: Assets.restaurantTierPlus,
          type: RestaurantTierOptionType.plus,
        ),
        RestaurantTierOptionEntity(
          name: 'ماكس',
          description: 'يشمل كل مطاعم سيلكت + مطاعم إضافية أكثر',
          restaurantCount: '+100',
          buttonLabel: 'ترقية إلى ماكس',
          badgeAsset: Assets.restaurantTierMax,
          type: RestaurantTierOptionType.max,
        ),
      ],
      currentPackageLabel: 'الباقة الحالية',
      currentTier: RestaurantTierPreviewEntity(
        name: 'سيلكت',
        badgeAsset: Assets.restaurantTierSelect,
      ),
      newTier: RestaurantTierPreviewEntity(
        name: 'بلس',
        badgeAsset: Assets.restaurantTierPlus,
      ),
      features: [
        RestaurantTierFeatureEntity(
          label: '25+ مطعم إضافي',
          icon: RestaurantTierFeatureIcon.restaurant,
        ),
        RestaurantTierFeatureEntity(
          label: 'مطاعم مميزة أكثر',
          icon: RestaurantTierFeatureIcon.reward,
        ),
        RestaurantTierFeatureEntity(
          label: 'خيارات أوسع',
          icon: RestaurantTierFeatureIcon.food,
        ),
      ],
      quickComparisonTitle: 'مقارنة سريعة',
      quickComparisonRows: [
        RestaurantTierComparisonRowEntity(
          packageLabel: 'الباقة الحالية:',
          tierName: 'سيلكت',
          badgeAsset: Assets.restaurantTierSelect,
          restaurantCountPrefix: 'حوالي',
          restaurantCount: '25+',
          restaurantCountSuffix: 'مطعم',
          caption: 'التصنيف الحالي',
        ),
        RestaurantTierComparisonRowEntity(
          packageLabel: 'الباقة الجديدة:',
          tierName: 'بلس',
          badgeAsset: Assets.restaurantTierPlus,
          restaurantCountPrefix: 'حوالي',
          restaurantCount: '50+',
          restaurantCountSuffix: 'مطعم',
          caption: 'يشمل كل مطاعم سيليكت + مطاعم إضافية',
        ),
      ],
      detailsTitle: 'تفاصيل الترقية',
      detailsRows: [
        RestaurantTierDetailRowEntity(
          label: 'الباقة الحالية: سيلكت',
          value: '6.500 د.ك',
        ),
        RestaurantTierDetailRowEntity(
          label: 'الباقة الجديدة: بلس',
          value: '12.000 د.ك',
        ),
        RestaurantTierDetailRowEntity(
          label: 'القيمة الحالية المدفوعة',
          value: '6.500 د.ك',
        ),
        RestaurantTierDetailRowEntity(label: 'فرق الترقية', value: '5.500 د.ك'),
        RestaurantTierDetailRowEntity(
          label: 'الضريبة (5%)',
          value: '0.275 د.ك',
        ),
      ],
      totalLabel: 'الإجمالي المستحق الآن',
      totalValue: '5.775 د.ك',
      applyNote: 'يتم تطبيق الترقية فورا حتى نهاية الاشتراك الحالي',
      paymentTitle: 'طريقة الدفع',
      paymentMethod: RestaurantTierPaymentMethodEntity(
        brand: 'VISA',
        cardText: 'فيزا •••• 4582',
        subtitle: 'البطاقة الافتراضية',
        changeLabel: 'تغيير',
      ),
      confirmLabel: 'تأكيد الترقية',
      backLabel: 'الرجوع',
    );
  }
}
