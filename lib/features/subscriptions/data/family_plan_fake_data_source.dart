import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanFakeDataSource {
  const FamilyPlanFakeDataSource();

  FamilyPlanEntity getPlan(AppLocalizations l10n) {
    return FamilyPlanEntity(
      title: l10n.family_plan_title,
      subtitle: l10n.family_plan_subtitle,
      badge: l10n.subscription_discount_20,
      statusLabel: l10n.family_plan_new,
      originalPrice: '72.000',
      discountedPrice: '57.600',
      currency: l10n.currency,
      features: [
        l10n.family_plan_feature_group_delivery,
        l10n.family_plan_feature_one_invoice,
        l10n.family_plan_feature_group_discount,
        l10n.family_plan_feature_all_meals,
        l10n.family_plan_feature_individual_plan,
      ],
      members: [
        FamilyMemberEntity(
          name: l10n.family_member_ahmed,
          imageAsset: Assets.familyMemberAhmed,
          mealsCount: l10n.family_meals_4,
          mealChecks: const [true, true, true, true],
          isOwner: true,
        ),
        FamilyMemberEntity(
          name: l10n.family_member_sarah,
          imageAsset: Assets.familyMemberSarah,
          mealsCount: l10n.family_meals_4,
          mealChecks: const [true, false, true, true],
          badgeColorHex: 0xFFFFEAD5,
          badgeTextColorHex: 0xFFFE6713,
        ),
        FamilyMemberEntity(
          name: l10n.family_member_yousef,
          imageAsset: Assets.familyMemberYousef,
          mealsCount: l10n.family_meals_4,
          mealChecks: const [true, true, true, true],
        ),
        FamilyMemberEntity(
          name: l10n.family_member_mariam,
          imageAsset: Assets.familyMemberMariam,
          mealsCount: l10n.family_meals_4,
          mealChecks: const [false, true, true, false],
          badgeColorHex: 0xFFEBE3F5,
          badgeTextColorHex: 0xFF7643BB,
        ),
      ],
      summaryStats: [
        FamilySummaryStatEntity(
          value: '4',
          label: l10n.family_current_members,
          iconName: 'users',
        ),
        FamilySummaryStatEntity(
          value: '4',
          label: l10n.family_max_members,
          iconName: 'users',
        ),
        FamilySummaryStatEntity(
          value: '16',
          label: l10n.family_total_daily_meals,
          iconName: 'meals',
        ),
        FamilySummaryStatEntity(
          value: '7.500',
          label: l10n.family_total_daily_calories,
          iconName: 'fire',
        ),
        FamilySummaryStatEntity(
          value: l10n.family_group_delivery,
          label: l10n.family_one_delivery,
          iconName: 'delivery',
        ),
      ],
      priceRows: [
        FamilyPriceRowEntity(
          label: l10n.family_base_price_two_members,
          value: '42.600 ${l10n.currency}',
        ),
        FamilyPriceRowEntity(
          label: l10n.family_extra_members_price,
          value: '15.000 ${l10n.currency}',
        ),
      ],
      totalLabel: l10n.family_total,
      totalPrice: '57.600 ${l10n.currency}',
    );
  }
}
