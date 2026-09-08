import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealSelectionCategoryChips extends StatelessWidget {
  const FamilyMealSelectionCategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final categories = [
      locale.family_meal_tab_all,
      locale.family_meal_tab_breakfast,
      locale.family_meal_tab_lunch,
      locale.family_meal_tab_dinner,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            if (i > 0) const SizedBox(width: Spacing.xs),
            InkWell(
              onTap: () => onSelected(i),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == i ? color.primary : color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  border: Border.all(
                    color: selectedIndex == i
                        ? color.primary
                        : color.outlineVariant,
                    width: Spacing.border,
                  ),
                ),
                child: Text(
                  categories[i],
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: selectedIndex == i
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
