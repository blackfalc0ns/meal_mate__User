import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_empty_results_section.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_filter_strip.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_result_card.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_section_title.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_suggestions_panel.dart';

class SearchActiveResultsSection extends StatelessWidget {
  const SearchActiveResultsSection({
    super.key,
    required this.suggestions,
    required this.query,
    required this.selectedFilter,
    required this.results,
    required this.onSuggestionTap,
    required this.onFilterSelected,
    required this.onExploreTap,
    required this.onClearTap,
  });

  final List<String> suggestions;
  final String query;
  final int selectedFilter;
  final List<SearchResult> results;
  final ValueChanged<String> onSuggestionTap;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback onExploreTap;
  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (results.isEmpty) {
      return SearchEmptyResultsSection(
        query: query,
        onSuggestionTap: onSuggestionTap,
        onExploreTap: onExploreTap,
        onClearTap: onClearTap,
      );
    }

    return ColoredBox(
      color: color.surface,
      child: ListView(
        key: const ValueKey('searching'),
        children: [
          SearchSuggestionsPanel(
            suggestions: suggestions,
            onSuggestionTap: onSuggestionTap,
          ),
          const SizedBox(height: Spacing.lg),
          SearchFilterStrip(
            selectedIndex: selectedFilter,
            onSelected: onFilterSelected,
          ),
          const SizedBox(height: Spacing.sm),
          SearchSectionTitle(
            title: locale.search_quick_results,
            icon: Icons.star_rounded,
          ),
          const SizedBox(height: Spacing.sm),
          Directionality(
            textDirection: TextDirection.ltr,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.md,
                mainAxisSpacing: Spacing.md,
                childAspectRatio: .74,
              ),
              itemBuilder: (context, index) =>
                  SearchResultCard(result: results[index]),
            ),
          ),
          const SizedBox(height: Spacing.bottomNavHeight + Spacing.xxxl),
        ],
      ),
    );
  }
}
