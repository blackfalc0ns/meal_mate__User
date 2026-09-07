import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyNoAllergiesTile extends StatelessWidget {
  const FamilyNoAllergiesTile({
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
      color: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.familyAllergiesNoneRadius),
        side: BorderSide(color: color.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.familyAllergiesNoneRadius),
        child: SizedBox(
          height: Spacing.familyAllergiesNoneHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.start,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                ),
                Container(
                  width: Spacing.familyAllergiesNoneIndicatorSize,
                  height: Spacing.familyAllergiesNoneIndicatorSize,
                  decoration: BoxDecoration(
                    color: selected ? color.primary : color.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? color.primary : color.outline,
                    ),
                  ),
                  child: selected
                      ? Icon(
                          Icons.check_rounded,
                          size: Spacing.iconSm,
                          color: color.onPrimary,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
