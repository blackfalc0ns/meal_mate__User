import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyDayDateArrowButton extends StatelessWidget {
  const FamilyDayDateArrowButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox.square(
      dimension: Spacing.familyDayDateNavSize,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(color: color.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.sm),
          ),
        ),
        child: Icon(
          icon,
          semanticLabel: locale.localeName,
          color: color.onSurface,
          size: Spacing.iconMd,
        ),
      ),
    );
  }
}
