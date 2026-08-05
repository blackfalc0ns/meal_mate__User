import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_empty_suggestion_chip.dart';

class SearchEmptyResultsSection extends StatelessWidget {
  const SearchEmptyResultsSection({
    super.key,
    required this.query,
    required this.onSuggestionTap,
    required this.onExploreTap,
    required this.onClearTap,
  });

  final String query;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onExploreTap;
  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final suggestions = [
      (
        label: locale.search_category_protein,
        icon: Icons.fitness_center_rounded,
      ),
      (label: locale.search_category_salad, icon: Icons.ramen_dining_rounded),
      (
        label: locale.search_empty_nearby_restaurants,
        icon: Icons.location_on_rounded,
      ),
    ];

    return ListView(
      key: const ValueKey('empty-results'),
      padding: const EdgeInsets.only(
        bottom: Spacing.bottomNavHeight + Spacing.xxxl,
      ),
      children: [
        const SizedBox(height: Spacing.searchEmptyTopGap),
        Image.asset(
          AssetsFake.searchEmptyResults,
          height: Spacing.searchEmptyImageHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: Spacing.searchEmptyTitleTopGap),
        Text(
          locale.search_empty_title,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size26,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: locale.search_empty_message_prefix),
              TextSpan(
                text: query,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.primary,
                ),
              ),
              TextSpan(text: locale.search_empty_message_suffix),
            ],
          ),
          textAlign: TextAlign.center,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.search_empty_description,
          textAlign: TextAlign.center,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xl),
        Text(
          locale.search_empty_suggestions_title,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            for (final suggestion in suggestions)
              SearchEmptySuggestionChip(
                label: suggestion.label,
                icon: suggestion.icon,
                onTap: () => onSuggestionTap(suggestion.label),
              ),
          ],
        ),
        const SizedBox(height: Spacing.xl),
        SizedBox(
          height: Spacing.searchEmptyButtonHeight,
          child: FilledButton.icon(
            onPressed: onExploreTap,
            icon: const Icon(Icons.explore_rounded, size: Spacing.iconMd),
            label: Text(
              locale.search_empty_explore,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onPrimary,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: color.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Spacing.searchEmptyButtonRadius,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.base),
        SizedBox(
          height: Spacing.searchEmptySuggestionHeight,
          child: OutlinedButton.icon(
            onPressed: onClearTap,
            icon: Icon(Icons.refresh_rounded, size: Spacing.iconMd),
            label: Text(
              locale.search_empty_clear,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: color.primary,
              side: BorderSide(color: color.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Spacing.searchEmptySuggestionRadius,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
