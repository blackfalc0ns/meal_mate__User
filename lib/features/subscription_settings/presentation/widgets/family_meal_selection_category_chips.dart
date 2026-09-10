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
        <(int, String, String?)>[
          (0, locale.family_meal_tab_all, null),
          (1, locale.family_meal_tab_breakfast, 'breakfast'),
          (2, locale.family_meal_tab_lunch, 'lunch'),
          (3, locale.family_meal_tab_dinner, 'dinner'),
          (4, locale.family_slot_snack, 'snack'),
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
                  horizontal: Spacing.base,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == categories[i].$1
                      ? color.primary
                      : color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  border: Border.all(
                    color: selectedIndex == categories[i].$1
                        ? color.primary
                        : color.outlineVariant,
                    width: Spacing.border,
                  ),
                ),
                child: Text(
                  categories[i].$2,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: selectedIndex == categories[i].$1
                        ? color.onPrimary
                        : color.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
