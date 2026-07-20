import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';

class SearchFakeDataSource {
  const SearchFakeDataSource();

  List<SearchQuickCategory> get quickCategories => const [
    SearchQuickCategory.salad,
    SearchQuickCategory.protein,
    SearchQuickCategory.juice,
    SearchQuickCategory.snack,
  ];

  List<SearchResult> get quickResults => const [
    SearchResult.meal,
    SearchResult.restaurant,
  ];

  SearchScreenContent getContent(AppLocalizations locale) {
    return SearchScreenContent(
      suggestions: [
        locale.search_recent_grilled_chicken,
        locale.search_suggestion_chicken_protein,
        locale.search_suggestion_chicken_rice,
        locale.search_suggestion_chicken_healthy,
        locale.search_suggestion_chicken_vegetables,
      ],
      categoryLabels: [
        locale.search_category_salad,
        locale.search_category_protein,
        locale.search_category_juice,
        locale.search_category_snack,
      ],
      categorySubtitles: [
        locale.search_category_salad_subtitle,
        locale.search_category_protein_subtitle,
        locale.search_category_juice_subtitle,
        locale.search_category_snack_subtitle,
      ],
      quickCategoryItems: [
        SearchQuickAction(
          label: locale.search_filter_meals,
          icon: Icons.ramen_dining_rounded,
        ),
        SearchQuickAction(
          label: locale.search_filter_restaurants,
          icon: Icons.storefront_rounded,
        ),
        SearchQuickAction(
          label: locale.search_filter_plans,
          icon: Icons.assignment_rounded,
        ),
        SearchQuickAction(
          label: locale.nav_offers,
          icon: Icons.card_giftcard_rounded,
        ),
      ],
    );
  }
}

class SearchScreenContent {
  const SearchScreenContent({
    required this.suggestions,
    required this.categoryLabels,
    required this.categorySubtitles,
    required this.quickCategoryItems,
  });

  final List<String> suggestions;
  final List<String> categoryLabels;
  final List<String> categorySubtitles;
  final List<SearchQuickAction> quickCategoryItems;
}

class SearchQuickAction {
  const SearchQuickAction({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

enum SearchQuickCategory {
  salad(AssetsFake.searchSalad),
  protein(AssetsFake.searchProtein),
  juice(AssetsFake.searchJuice),
  snack(AssetsFake.searchSnack);

  const SearchQuickCategory(this.imageAsset);

  final String imageAsset;
}

enum SearchResult {
  meal(AssetsFake.searchFeaturedMeal),
  restaurant(AssetsFake.searchHealthyRestaurant);

  const SearchResult(this.imageAsset);

  final String imageAsset;
}
