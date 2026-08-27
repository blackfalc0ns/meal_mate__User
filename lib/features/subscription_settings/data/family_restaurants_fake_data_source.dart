import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class FamilyRestaurantsFakeDataSource {
  const FamilyRestaurantsFakeDataSource();

  FamilyRestaurantsPageData getContent(AppLocalizations locale) {
    return FamilyRestaurantsPageData(
      memberName: locale.family_restaurants_member_ahmed,
      dateLabel: locale.family_restaurants_date_label,
      searchHint: locale.family_restaurants_search_hint,
      subtitle: locale.family_restaurants_subtitle,
      members: [
        FamilyRestaurantsMemberData(
          name: locale.family_member_mariam,
          imageAsset: AssetsFake.familyMemberMariam,
        ),
        FamilyRestaurantsMemberData(
          name: locale.family_member_yousef,
          imageAsset: AssetsFake.familyMemberYousef,
        ),
        FamilyRestaurantsMemberData(
          name: locale.family_member_sarah,
          imageAsset: AssetsFake.familyMemberSarah,
        ),
        FamilyRestaurantsMemberData(
          name: locale.family_restaurants_member_ahmed,
          imageAsset: AssetsFake.familyMemberAhmed,
          isSelected: true,
        ),
      ],
      summary: FamilyRestaurantsSummaryData(
        selectedMeals: locale.family_restaurants_summary_selected_meals_value,
        selectedMealsTotal:
            locale.family_restaurants_summary_selected_meals_total,
        selectedMealsLabel:
            locale.family_restaurants_summary_selected_meals_label,
        dailyMeals: locale.family_restaurants_summary_daily_meals_value,
        dailyMealsLabel: locale.family_restaurants_summary_daily_meals_label,
        calories: locale.family_restaurants_summary_calories_value,
        caloriesLabel: locale.family_restaurants_summary_calories_label,
        programLabel: locale.family_restaurants_filter_balanced,
      ),
      filters: [
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_dinner,
          icon: Icons.nightlight_round,
        ),
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_lunch,
          icon: Icons.wb_sunny_rounded,
        ),
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_breakfast,
          icon: Icons.wb_sunny_rounded,
        ),
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_balanced,
          icon: Icons.balance_rounded,
        ),
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_high_protein,
          icon: Icons.eco_rounded,
        ),
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_all,
          isSelected: true,
        ),
      ],
      restaurants: [
        FamilyRestaurantCardData(
          name: locale.family_restaurants_diet_house,
          subtitle: locale.family_restaurants_card_subtitle,
          imageAsset: AssetsFake.familyDietHouseMeal,
          logoLine1: locale.family_restaurants_logo_diet_house_line1,
          logoLine2: locale.family_restaurants_logo_diet_house_line2,
          rating: locale.family_restaurants_rating_diet_house,
          tags: [
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_lunch,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_balanced,
              icon: Icons.balance_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_high_protein,
              icon: Icons.eco_rounded,
            ),
          ],
          buttonLabel: locale.family_restaurants_browse_meals,
        ),
        FamilyRestaurantCardData(
          name: locale.family_restaurants_healthy_bowl,
          subtitle: locale.family_restaurants_card_subtitle,
          imageAsset: AssetsFake.familyHealthyBowlMeal,
          logoLine1: locale.family_restaurants_logo_healthy_bowl_line1,
          logoLine2: locale.family_restaurants_logo_healthy_bowl_line2,
          rating: locale.family_restaurants_rating_healthy_bowl,
          tags: [
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_lunch,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_balanced,
              icon: Icons.balance_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_dinner,
              icon: Icons.nightlight_round,
            ),
          ],
          buttonLabel: locale.family_restaurants_browse_meals,
        ),
        FamilyRestaurantCardData(
          name: locale.family_restaurants_protein_kitchen,
          subtitle: locale.family_restaurants_card_subtitle,
          imageAsset: AssetsFake.familyProteinKitchenMeal,
          logoLine1: locale.family_restaurants_logo_protein_kitchen_line1,
          logoLine2: locale.family_restaurants_logo_protein_kitchen_line2,
          logoLine3: locale.family_restaurants_logo_protein_kitchen_line3,
          rating: locale.family_restaurants_rating_protein_kitchen,
          tags: [
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_lunch,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_breakfast,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_balanced,
              icon: Icons.balance_rounded,
            ),
          ],
          buttonLabel: locale.family_restaurants_browse_meals,
          darkLogo: true,
        ),
        FamilyRestaurantCardData(
          name: locale.family_restaurants_salad_station,
          subtitle: locale.family_restaurants_card_subtitle,
          imageAsset: AssetsFake.familySaladStationMeal,
          logoLine1: locale.family_restaurants_logo_salad_station_line1,
          logoLine2: locale.family_restaurants_logo_salad_station_line2,
          rating: locale.family_restaurants_rating_salad_station,
          tags: [
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_lunch,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_breakfast,
              icon: Icons.wb_sunny_rounded,
            ),
            FamilyRestaurantsFilterData(
              label: locale.family_restaurants_filter_balanced,
              icon: Icons.balance_rounded,
            ),
          ],
          buttonLabel: locale.family_restaurants_browse_meals,
        ),
      ],
      assuranceTitle: locale.family_restaurants_assurance_title,
      assuranceSubtitle: locale.family_restaurants_assurance_subtitle,
    );
  }
}

class FamilyRestaurantsPageData {
  const FamilyRestaurantsPageData({
    required this.memberName,
    required this.dateLabel,
    required this.searchHint,
    required this.subtitle,
    required this.members,
    required this.summary,
    required this.filters,
    required this.restaurants,
    required this.assuranceTitle,
    required this.assuranceSubtitle,
  });

  final String memberName;
  final String dateLabel;
  final String searchHint;
  final String subtitle;
  final List<FamilyRestaurantsMemberData> members;
  final FamilyRestaurantsSummaryData summary;
  final List<FamilyRestaurantsFilterData> filters;
  final List<FamilyRestaurantCardData> restaurants;
  final String assuranceTitle;
  final String assuranceSubtitle;
}

class FamilyRestaurantsSummaryData {
  const FamilyRestaurantsSummaryData({
    required this.selectedMeals,
    required this.selectedMealsTotal,
    required this.selectedMealsLabel,
    required this.dailyMeals,
    required this.dailyMealsLabel,
    required this.calories,
    required this.caloriesLabel,
    required this.programLabel,
  });

  final String selectedMeals;
  final String selectedMealsTotal;
  final String selectedMealsLabel;
  final String dailyMeals;
  final String dailyMealsLabel;
  final String calories;
  final String caloriesLabel;
  final String programLabel;
}

class FamilyRestaurantsMemberData {
  const FamilyRestaurantsMemberData({
    required this.name,
    required this.imageAsset,
    this.isSelected = false,
  });

  final String name;
  final String imageAsset;
  final bool isSelected;
}

class FamilyRestaurantsFilterData {
  const FamilyRestaurantsFilterData({
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
}

class FamilyRestaurantCardData {
  const FamilyRestaurantCardData({
    required this.name,
    required this.subtitle,
    required this.imageAsset,
    required this.logoLine1,
    required this.logoLine2,
    required this.rating,
    required this.tags,
    required this.buttonLabel,
    this.logoLine3,
    this.darkLogo = false,
  });

  final String name;
  final String subtitle;
  final String imageAsset;
  final String logoLine1;
  final String logoLine2;
  final String? logoLine3;
  final String rating;
  final List<FamilyRestaurantsFilterData> tags;
  final String buttonLabel;
  final bool darkLogo;
}
