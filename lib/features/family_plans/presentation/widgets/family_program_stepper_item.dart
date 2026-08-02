import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyProgramStepperItem extends StatelessWidget {
  const FamilyProgramStepperItem({
    super.key,
    required this.label,
    required this.value,
    this.number,
    this.selected = false,
  });

  final String label;
  final String value;
  final String? number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Container(
          width: Spacing.familyProgramStepCircleSize,
          height: Spacing.familyProgramStepCircleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color.primary : color.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? color.primary : color.outline,
            ),
          ),
          child: selected
              ? Icon(
                  Icons.check_rounded,
                  color: color.onPrimary,
                  size: Spacing.iconSm,
                  semanticLabel: locale.family_step_program,
                )
              : Text(
                  number ?? locale.family_setup_step_one,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
