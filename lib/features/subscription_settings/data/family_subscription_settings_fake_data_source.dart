import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionSettingsFakeDataSource {
  const FamilySubscriptionSettingsFakeDataSource();

  FamilySubscriptionSettingsEntity getSettings() {
    return const FamilySubscriptionSettingsEntity(
      title: 'الباقة العائلية',
      subtitle: 'خطة متكاملة حتى 6 أفراد',
      statusLabel: 'نشط',
      originalPrice: '72.000',
      discountedPrice: '57.600',
      currency: 'KWD',
      endsOn: 'ينتهي في 26 مايو 2024',
      heroImageAsset: Assets.familyManagePlanCard,
      members: [
        FamilySubscriptionMemberEntity(
          name: 'مريم',
          imageAsset: AssetsFake.familyMemberMariam,
          statusLabel: 'مكتمل',
          isComplete: true,
        ),
        FamilySubscriptionMemberEntity(
          name: 'يوسف',
          imageAsset: AssetsFake.familyMemberYousef,
          statusLabel: 'اختيار ناقص',
          isComplete: false,
        ),
        FamilySubscriptionMemberEntity(
          name: 'سارة',
          imageAsset: AssetsFake.familyMemberSarah,
          statusLabel: 'اختيار ناقص',
          isComplete: false,
        ),
        FamilySubscriptionMemberEntity(
          name: 'أحمد',
          imageAsset: AssetsFake.familyMemberAhmed,
          statusLabel: 'مكتمل',
          isComplete: true,
        ),
      ],
      quickActions: [
        FamilySubscriptionQuickActionEntity(
          label: 'الصلاحيات',
          iconAsset: Assets.familyManagePermissions,
        ),
        FamilySubscriptionQuickActionEntity(
          label: 'الفاتورة',
          iconAsset: Assets.familyManageInvoice,
        ),
        FamilySubscriptionQuickActionEntity(
          label: 'الاشتراك',
          iconAsset: Assets.familyManageSubscription,
        ),
        FamilySubscriptionQuickActionEntity(
          label: 'الوجبات',
          iconAsset: Assets.familyManageMeals,
        ),
      ],
      mealStatuses: [
        FamilySubscriptionMealStatusEntity(
          memberName: 'أحمد',
          memberImageAsset: AssetsFake.familyMemberAhmed,
          mealsLabel: '4/4 وجبات',
          statusLabel: 'مكتملة',
          progress: 1,
          status: FamilySubscriptionMealStatus.completed,
        ),
        FamilySubscriptionMealStatusEntity(
          memberName: 'سارة',
          memberImageAsset: AssetsFake.familyMemberSarah,
          mealsLabel: '2/4 وجبات',
          statusLabel: 'تم الاختيار',
          progress: 0.5,
          status: FamilySubscriptionMealStatus.selected,
        ),
        FamilySubscriptionMealStatusEntity(
          memberName: 'يوسف',
          memberImageAsset: AssetsFake.familyMemberYousef,
          mealsLabel: '0/4 وجبة',
          statusLabel: 'لم يبدأ',
          progress: 0,
          status: FamilySubscriptionMealStatus.missing,
        ),
        FamilySubscriptionMealStatusEntity(
          memberName: 'سارة',
          memberImageAsset: AssetsFake.familyMemberSarah,
          mealsLabel: '4/4 وجبات',
          statusLabel: 'مكتملة',
          progress: 1,
          status: FamilySubscriptionMealStatus.completed,
        ),
      ],
      warningTitle: 'يوجد أفراد لم يتم اختيار وجباتهم',
      warningMessage: 'يرجى اختيار وجبات اليوم للفرد : أحمد',
    );
  }
}
