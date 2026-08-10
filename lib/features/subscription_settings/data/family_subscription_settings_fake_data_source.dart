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

  FamilySubscriptionMembersPageEntity getMembersPage() {
    return const FamilySubscriptionMembersPageEntity(
      members: [
        FamilySubscriptionListMemberEntity(
          name: 'أحمد',
          imageAsset: AssetsFake.familyMemberAhmed,
          accountLabel: 'لديه حساب',
          programLabel: 'متوازن',
          mealsLabel: '4 وجبات',
          daysLabel: '7 أيام',
          statusLabel: 'نشط',
          status: FamilySubscriptionListMemberStatus.active,
          noteLabel: 'جميع الوجبات يديرها المسؤول',
          noteStatus: FamilySubscriptionListMemberNoteStatus.success,
          goal: FamilySubscriptionListMemberGoal.balanced,
        ),
        FamilySubscriptionListMemberEntity(
          name: 'سارة',
          imageAsset: AssetsFake.familyMemberSarah,
          accountLabel: 'لديه حساب',
          programLabel: 'خسارة الوزن',
          mealsLabel: '4 وجبات',
          daysLabel: '7 أيام',
          statusLabel: 'نشط',
          status: FamilySubscriptionListMemberStatus.active,
          noteLabel: 'تم تخصيص بعض الوجبات',
          noteStatus: FamilySubscriptionListMemberNoteStatus.warning,
          goal: FamilySubscriptionListMemberGoal.weightLoss,
        ),
        FamilySubscriptionListMemberEntity(
          name: 'يوسف',
          imageAsset: AssetsFake.familyMemberYousef,
          accountLabel: 'لديه حساب',
          programLabel: 'بناء عضلات',
          mealsLabel: '4 وجبات',
          daysLabel: '7 أيام',
          statusLabel: 'قيد الإعداد',
          status: FamilySubscriptionListMemberStatus.setup,
          noteLabel: 'جميع الوجبات يديرها المسؤول',
          noteStatus: FamilySubscriptionListMemberNoteStatus.warning,
          goal: FamilySubscriptionListMemberGoal.muscleGain,
        ),
        FamilySubscriptionListMemberEntity(
          name: 'مريم',
          imageAsset: AssetsFake.familyMemberMariam,
          accountLabel: 'لديه حساب',
          programLabel: 'متوازن',
          mealsLabel: '4 وجبات',
          daysLabel: '7 أيام',
          statusLabel: 'قيد الإعداد',
          status: FamilySubscriptionListMemberStatus.setup,
          noteLabel: 'لم يتم اختيار النظام',
          noteStatus: FamilySubscriptionListMemberNoteStatus.error,
          goal: FamilySubscriptionListMemberGoal.balanced,
        ),
      ],
    );
  }

  FamilyMemberDetailEntity getMemberDetail() {
    return const FamilyMemberDetailEntity(
      title: 'تفاصيل أحمد',
      name: 'أحمد',
      imageAsset: AssetsFake.familyMemberAhmed,
      ageLabel: '24 سنة',
      statusLabel: 'نشط',
      roleLabel: 'عضو أساسي',
      programTitle: 'البرنامج الغذائي',
      programImageAsset: AssetsFake.familyMemberProgramBalanced,
      programName: 'متوازن',
      changeProgramLabel: 'تغيير البرنامج',
      packageTitle: 'الباقة',
      remainingDaysLabel: '7 أيام متبقية',
      packageDescription: '4 وجبات يومياً + سناك',
      editPackageLabel: 'تعديل الباقة',
      selectionTitle: 'إجمالي الاختيارات',
      completedValue: '6/4',
      completedLabel: 'أيام مكتملة',
      progress: 0.62,
      showCalendarLabel: 'عرض التقويم',
      shortcuts: [
        FamilyMemberDetailShortcutEntity(
          title: 'الوجبات اليومية',
          subtitle: 'عرض الوجبات والخطط',
          type: FamilyMemberDetailShortcutType.dailyMeals,
        ),
        FamilyMemberDetailShortcutEntity(
          title: 'الصلاحيات',
          subtitle: 'عرض وإدرة الصلاحيات',
          type: FamilyMemberDetailShortcutType.permissions,
        ),
      ],
    );
  }

  FamilyMemberPermissionsPageEntity getMemberPermissions() {
    return const FamilyMemberPermissionsPageEntity(
      memberName: 'أحمد',
      memberImageAsset: AssetsFake.familyDayMemberAhmed,
      sections: [
        FamilyMemberPermissionSectionEntity(
          iconType: FamilyMemberPermissionSectionIconType.meals,
          permissions: [
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.chooseDailyMeals,
              enabled: true,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.editMealsBeforeLock,
              enabled: true,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.viewMealDetails,
              enabled: true,
            ),
          ],
        ),
        FamilyMemberPermissionSectionEntity(
          iconType: FamilyMemberPermissionSectionIconType.program,
          permissions: [
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.viewNutritionProgram,
              enabled: true,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.changeNutritionProgram,
              enabled: false,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.editMealsAndDaysCount,
              enabled: false,
            ),
          ],
        ),
        FamilyMemberPermissionSectionEntity(
          iconType: FamilyMemberPermissionSectionIconType.settings,
          permissions: [
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.editAddress,
              enabled: true,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.replaceMeal,
              enabled: true,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.viewReportsAndPayments,
              enabled: false,
            ),
            FamilyMemberPermissionEntity(
              type: FamilyMemberPermissionType.leaveFamilyPlan,
              enabled: false,
            ),
          ],
        ),
      ],
    );
  }
}
