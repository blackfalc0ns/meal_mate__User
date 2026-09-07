import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_choice_tile.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';

class FamilyAllergySelectionSection extends StatelessWidget {
  const FamilyAllergySelectionSection({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.selected,
    required this.onSearch,
    required this.onToggle,
  });

  final String title;
  final String searchHint;
  final List<FoodPreferenceCatalogItemEntity> items;
  final Set<String> selected;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.familyAllergiesCardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.familyAllergiesCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.06),
            blurRadius: Spacing.radiusLg,
            offset: const Offset(Spacing.zero, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: Spacing.familyAllergiesSearchHeight,
            child: TextField(
              onChanged: onSearch,
              textAlign: TextAlign.start,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
                suffixIcon: Icon(
                  Icons.search_rounded,
                  size: Spacing.iconLg,
                  color: color.onSurfaceVariant,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Spacing.familyAllergiesSearchRadius,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Spacing.familyAllergiesChoiceHeight,
              crossAxisSpacing: Spacing.familyAllergiesChoiceColumnGap,
              mainAxisSpacing: Spacing.familyAllergiesChoiceGap,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return FamilyAllergyChoiceTile(
                label: item.name(locale.localeName),
                selected: selected.contains(item.code),
                onTap: () => onToggle(item.code),
              );
            },
          ),
        ],
      ),
    );
  }
}
