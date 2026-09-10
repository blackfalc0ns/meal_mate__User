import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealSelectionCategoryChips extends StatelessWidget {
  const FamilyMealSelectionCategoryChips({
    super.key,
    required this.selectedIndex,
    required this.availableSlots,
    required this.onSelected,
  });

  final int selectedIndex;
  final Set<String> availableSlots;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final categories =
        <(int, String, String?, IconData?, Color?)>[
          (0, locale.family_meal_tab_all, null, null, null),
          (
            1,
            locale.family_meal_tab_breakfast,
            'breakfast',
            Icons.wb_sunny_rounded,
            color.secondary,
          ),
          (
            2,
            locale.family_meal_tab_lunch,
            'lunch',
            Icons.wb_sunny_rounded,
            color.secondary,
          ),
          (
            3,
            locale.family_meal_tab_dinner,
            'dinner',
            Icons.nightlight_round,
            color.tertiary,
          ),
          (
            4,
            locale.family_slot_snack,
            'snack',
            Icons.cookie_outlined,
            color.secondary,
          ),
        ].where((category) {
          final slot = category.$3;
          return slot == null || availableSlots.contains(slot);
        }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            if (i > 0) const SizedBox(width: Spacing.xs),
            InkWell(
              onTap: () => onSelected(categories[i].$1),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == categories[i].$1
                      ? color.primary.withValues(alpha: 0.08)
                      : color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  border: Border.all(
                    color: selectedIndex == categories[i].$1
                        ? color.primary
                        : color.outlineVariant,
                    width: Spacing.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (categories[i].$4 != null) ...[
                      Icon(
                        categories[i].$4,
                        size: Spacing.iconXs,
                        color: selectedIndex == categories[i].$1
                            ? color.primary
                            : categories[i].$5,
                      ),
                      const SizedBox(width: Spacing.xs / 2),
                    ],
                    Text(
                      categories[i].$2,
                      style: selectedIndex == categories[i].$1
                          ? getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            )
                          : getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
