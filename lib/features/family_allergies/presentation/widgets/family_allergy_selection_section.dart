import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_expand_button.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_choice_tile.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';

class FamilyAllergySelectionSection extends StatefulWidget {
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
  State<FamilyAllergySelectionSection> createState() =>
      _FamilyAllergySelectionSectionState();
}

class _FamilyAllergySelectionSectionState
    extends State<FamilyAllergySelectionSection> {
  static const _collapsedItemCount = 6;

  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant FamilyAllergySelectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length <= _collapsedItemCount) {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final canExpand = widget.items.length > _collapsedItemCount;
    final visibleItems = _isExpanded || !canExpand
        ? widget.items
        : widget.items.take(_collapsedItemCount).toList();

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
            widget.title,
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
              onChanged: widget.onSearch,
              textAlign: TextAlign.start,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.searchHint,
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
          AnimatedSize(
            duration: AppDurations.normal,
            reverseDuration: AppDurations.fast,
            curve: Curves.easeOutCubic,
            alignment: AlignmentDirectional.topCenter,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: Spacing.familyAllergiesChoiceHeight,
                crossAxisSpacing: Spacing.familyAllergiesChoiceColumnGap,
                mainAxisSpacing: Spacing.familyAllergiesChoiceGap,
              ),
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                return FamilyAllergyChoiceTile(
                  label: item.name(locale.localeName),
                  selected: widget.selected.contains(item.code),
                  onTap: () => widget.onToggle(item.code),
                );
              },
            ),
          ),
          if (canExpand) ...[
            const SizedBox(height: Spacing.xs),
            FamilyAllergiesExpandButton(
              expanded: _isExpanded,
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ],
        ],
      ),
    );
  }
}
