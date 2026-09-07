import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAllergyChoiceTile extends StatelessWidget {
  const FamilyAllergyChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: selected ? color.primaryContainer : color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Spacing.familyAllergiesChoiceRadius,
        ),
        side: BorderSide(
          color: selected ? color.primary : color.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          Spacing.familyAllergiesChoiceRadius,
        ),
        child: SizedBox(
          height: Spacing.familyAllergiesChoiceHeight,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.md,
              end: Spacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: selected ? color.primary : color.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: Spacing.familyAllergiesChoiceIndicatorSize,
                    height: Spacing.familyAllergiesChoiceIndicatorSize,
                    decoration: BoxDecoration(
                      color: color.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: Spacing.familyAllergiesChoiceCheckSize,
                      color: color.onPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
