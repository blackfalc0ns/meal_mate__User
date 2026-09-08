import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class FamilyMealSelectionFakeDataSource {
  const FamilyMealSelectionFakeDataSource();

  FamilyMealSelectionData getContent(AppLocalizations locale) {
    return FamilyMealSelectionData(
      memberName: locale.family_restaurants_member_ahmed,
      restaurantName: locale.family_restaurants_protein_kitchen,
      slotName: locale.family_slot_lunch,
      dateLabel: locale.family_restaurants_date_label,
      macros: const FamilyMacrosSummaryData(
        calories: 1440,
        protein: 120,
        carbs: 142,
        fat: 36,
      ),
      selectedCount: 4,
      totalCount: 4,
      meals: [
        FamilyMealItemData(
          id: '1',
          title: locale.family_meal_item_1_title,
          description: locale.family_meal_item_1_desc,
          calories: 480,
          protein: 42,
          carbs: 48,
          fat: 12,
          tags: [
            locale.family_meal_tag_gluten_free,
            locale.family_meal_tag_contains_nuts,
          ],
          imageAsset: AssetsFake.familyProteinKitchenMeal,
          isSelected: true,
        ),
        FamilyMealItemData(
          id: '2',
          title: locale.family_meal_item_2_title,
          description: locale.family_meal_item_2_desc,
          calories: 480,
          protein: 42,
          carbs: 48,
          fat: 12,
          tags: [
            locale.family_meal_tag_gluten_free,
            locale.family_meal_tag_omega3,
          ],
          imageAsset: AssetsFake.familyDaySalmon,
          isSelected: false,
        ),
        FamilyMealItemData(
          id: '3',
          title: locale.family_meal_item_3_title,
          description: locale.family_meal_item_3_desc,
          calories: 480,
          protein: 42,
          carbs: 48,
          fat: 12,
          tags: [
            locale.family_meal_tag_gluten_free,
            locale.family_meal_tag_omega3,
          ],
          imageAsset: AssetsFake.familyCalendarChickenRice,
          isSelected: false,
        ),
        FamilyMealItemData(
          id: '4',
          title: locale.family_meal_item_4_title,
          description: locale.family_meal_item_4_desc,
          calories: 480,
          protein: 42,
          carbs: 48,
          fat: 12,
          tags: [
            locale.family_meal_tag_gluten_free,
            locale.family_meal_tag_omega3,
          ],
          imageAsset: AssetsFake.familySaladStationMeal,
          isSelected: false,
        ),
      ],
    );
  }
}

class FamilyMealSelectionData {
  const FamilyMealSelectionData({
    required this.memberName,
    required this.restaurantName,
    required this.slotName,
    required this.dateLabel,
    required this.macros,
    required this.selectedCount,
    required this.totalCount,
    required this.meals,
  });

  final String memberName;
  final String restaurantName;
  final String slotName;
  final String dateLabel;
  final FamilyMacrosSummaryData macros;
  final int selectedCount;
  final int totalCount;
  final List<FamilyMealItemData> meals;
}

class FamilyMacrosSummaryData {
  const FamilyMacrosSummaryData({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}

class FamilyMealItemData {
  const FamilyMealItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.tags,
    required this.imageAsset,
    this.isSelected = false,
  });

  final String id;
  final String title;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final List<String> tags;
  final String imageAsset;
  final bool isSelected;
}
