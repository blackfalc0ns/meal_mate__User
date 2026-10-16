import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
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
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
          horizontal: Spacing.sm,
        ),
      ),
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
      icon: Icon(
        expanded
            ? Icons.keyboard_arrow_up_rounded
            : Icons.keyboard_arrow_down_rounded,
        size: Spacing.iconSm,
        color: color.primary,
      ),
    );
  }
}
