import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAllergiesExpandButton extends StatelessWidget {
  const FamilyAllergiesExpandButton({
    super.key,
    required this.expanded,
    required this.onPressed,
  });

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return TextButton.icon(
      onPressed: onPressed,
      iconAlignment: IconAlignment.end,
      label: Text(
        expanded
            ? locale.family_allergies_show_less
            : locale.family_allergies_show_more,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size10,
          color: color.primary,
        ),
      ),
      icon: AnimatedRotation(
        turns: expanded ? 0.5 : 0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: Spacing.iconSm,
          color: color.primary,
        ),
      ),
    );
  }
}
