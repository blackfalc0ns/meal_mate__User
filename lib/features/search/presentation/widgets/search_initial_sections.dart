import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_quick_category_strip.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_result_card.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_section_title.dart';

class SearchInitialSections extends StatelessWidget {
  const SearchInitialSections({
    super.key,
    required this.content,
    required this.categories,
    required this.results,
    required this.onQuery,
  });

  final SearchScreenContent content;
  final List<SearchQuickCategory> categories;
  final List<SearchResult> results;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final recentSearches = [
      locale.search_recent_grilled_chicken,
      locale.search_recent_healthy_restaurants,
      locale.search_recent_high_protein,
    ];

    return ListView(
      key: const ValueKey('initial'),
      children: [
        SearchSectionTitle(
          title: locale.search_recent,
          icon: Icons.history_rounded,
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: Spacing.xxxl - Spacing.xss,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentSearches.length,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (context, index) {
                final label = recentSearches[index];
                return ActionChip(
                  onPressed: () => onQuery(label),
                  avatar: Icon(
                    Icons.search_rounded,
                    color: color.onPrimary,
                    size: Spacing.iconSm,
                  ),
                  backgroundColor: color.primary,
                  side: BorderSide.none,
                  label: Text(
                    label,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size10,
                      color: color.onPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        SearchSectionTitle(
          title: locale.search_popular,
          icon: Icons.bar_chart_rounded,
        ),
        const SizedBox(height: Spacing.sm),
        SearchQuickCategoryStrip(
          categories: categories,
          labels: content.categoryLabels,
          subtitles: content.categorySubtitles,
          onCategoryTap: (_) => onQuery(locale.search_recent_grilled_chicken),
        ),
        const SizedBox(height: Spacing.lg),
        SearchSectionTitle(
          title: locale.search_categories,
          icon: Icons.grid_view_rounded,
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: Spacing.searchQuickCategoryCardHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth =
                  content.quickCategoryItems.length *
                      Spacing.searchQuickCategoryCardWidth +
                  (content.quickCategoryItems.length - 1) *
                      Spacing.searchQuickCategoryGap;
              final horizontalPadding =
                  ((constraints.maxWidth - contentWidth) / 2)
                      .clamp(0.0, double.infinity)
                      .toDouble();

              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: content.quickCategoryItems.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: Spacing.searchQuickCategoryGap),
                  itemBuilder: (context, index) {
                    final item = content.quickCategoryItems[index];
                    return Container(
                      width: Spacing.searchQuickCategoryCardWidth,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                        vertical: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: color.surface,
                        border: Border.all(color: color.outlineVariant),
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: color.primary,
                            size: Spacing.iconLg,
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size10,
                              color: color.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: Spacing.lg),
        SearchSectionTitle(
          title: locale.search_recommended,
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
              childAspectRatio: .78,
            ),
            itemBuilder: (context, index) =>
                SearchResultCard(result: results[index]),
          ),
        ),
        const SizedBox(height: Spacing.xxxl),
      ],
    );
  }
}
