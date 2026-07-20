import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_quick_category_tile.dart';

class SearchQuickCategoryStrip extends StatelessWidget {
  const SearchQuickCategoryStrip({
    super.key,
    required this.categories,
    required this.labels,
    required this.subtitles,
    required this.onCategoryTap,
  });

  final List<SearchQuickCategory> categories;
  final List<String> labels;
  final List<String> subtitles;
  final ValueChanged<int> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.search_popular,
      child: ColoredBox(
        color: color.surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                categories.length * Spacing.searchPopularCardWidth +
                (categories.length - 1) * Spacing.sm;
            final horizontalPadding =
                ((constraints.maxWidth - contentWidth) / 2)
                    .clamp(0.0, double.infinity)
                    .toDouble();

            return SizedBox(
              height: Spacing.searchPopularCardHeight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                  itemBuilder: (context, index) {
                    final categoryIndex = categories.length - index - 1;
                    return SearchQuickCategoryTile(
                      imageAsset: categories[categoryIndex].imageAsset,
                      label: labels[categoryIndex],
                      subtitle: subtitles[categoryIndex],
                      onTap: () => onCategoryTap(categoryIndex),
                      width: Spacing.searchPopularCardWidth,
                      height: Spacing.searchPopularCardHeight,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
