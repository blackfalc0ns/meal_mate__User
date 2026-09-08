import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class FamilyReviewMealsFakeDataSource {
  const FamilyReviewMealsFakeDataSource();

  FamilyReviewMemberMealsData getContent(AppLocalizations locale) {
    return FamilyReviewMemberMealsData(
      memberName: locale.family_restaurants_member_ahmed,
      statusLabel: locale.family_review_status_ready,
      dateLabel: locale.family_restaurants_date_label,
      goalLabel: locale.family_review_goal_balanced,
      avatarAsset: AssetsFake.familyMemberAhmed,
      slots: [
        FamilyReviewMealSlotData(
          slotType: locale.family_slot_breakfast,
          mealName: locale.family_review_meal_1_name,
          restaurantName: locale.family_restaurants_diet_house,
          imageAsset: AssetsFake.familyDayBreakfast,
        ),
        FamilyReviewMealSlotData(
          slotType: locale.family_slot_lunch,
          mealName: locale.family_review_meal_2_name,
          restaurantName: locale.family_restaurants_diet_house,
          imageAsset: AssetsFake.familyProteinKitchenMeal,
        ),
        FamilyReviewMealSlotData(
          slotType: locale.family_slot_dinner,
          mealName: locale.family_review_meal_3_name,
          restaurantName: locale.family_restaurants_diet_house,
          imageAsset: AssetsFake.familyDaySalmon,
        ),
        FamilyReviewMealSlotData(
          slotType: locale.family_slot_snack,
          mealName: locale.family_review_meal_4_name,
          restaurantName: locale.family_restaurants_diet_house,
          imageAsset: AssetsFake.familyDaySnack,
        ),
      ],
      nutrition: const FamilyReviewNutritionalProgressData(
        caloriesCurrent: 1580,
        caloriesTarget: 1800,
        proteinCurrent: 89,
        proteinTarget: 120,
        carbsCurrent: 210,
        carbsTarget: 260,
        fatCurrent: 58,
        fatTarget: 75,
      ),
      instructions: [
        locale.family_review_tag_no_nuts,
        locale.family_review_tag_brown_rice,
        locale.family_review_tag_not_spicy,
      ],
      instructionsNote: locale.family_review_preferences_note,
      cutoffTitle: locale.family_review_cutoff_title,
      cutoffDescription: locale.family_review_cutoff_desc,
      cutoffRemainingTime: '22 ساعة و 18 دقيقة',
      cutoffDisclaimer: locale.family_review_cutoff_disclaimer,
    );
  }
}

class FamilyReviewMemberMealsData {
  const FamilyReviewMemberMealsData({
    required this.memberName,
    required this.statusLabel,
    required this.dateLabel,
    required this.goalLabel,
    required this.avatarAsset,
    required this.slots,
    required this.nutrition,
    required this.instructions,
    required this.instructionsNote,
    required this.cutoffTitle,
    required this.cutoffDescription,
    required this.cutoffRemainingTime,
    required this.cutoffDisclaimer,
  });

  final String memberName;
  final String statusLabel;
  final String dateLabel;
  final String goalLabel;
  final String avatarAsset;
  final List<FamilyReviewMealSlotData> slots;
  final FamilyReviewNutritionalProgressData nutrition;
  final List<String> instructions;
  final String instructionsNote;
  final String cutoffTitle;
  final String cutoffDescription;
  final String cutoffRemainingTime;
  final String cutoffDisclaimer;
}

class FamilyReviewMealSlotData {
  const FamilyReviewMealSlotData({
    required this.slotType,
    required this.mealName,
    required this.restaurantName,
    required this.imageAsset,
  });

  final String slotType;
  final String mealName;
  final String restaurantName;
  final String imageAsset;
}

class FamilyReviewNutritionalProgressData {
  const FamilyReviewNutritionalProgressData({
    required this.caloriesCurrent,
    required this.caloriesTarget,
    required this.proteinCurrent,
    required this.proteinTarget,
    required this.carbsCurrent,
    required this.carbsTarget,
    required this.fatCurrent,
    required this.fatTarget,
  });

  final int caloriesCurrent;
  final int caloriesTarget;
  final int proteinCurrent;
  final int proteinTarget;
  final int carbsCurrent;
  final int carbsTarget;
  final int fatCurrent;
  final int fatTarget;
}
