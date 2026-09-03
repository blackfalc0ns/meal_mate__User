import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsBottomActionButton extends StatelessWidget {
  const MealDetailsBottomActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color.primary,
          foregroundColor: color.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, size: Spacing.iconMd),
            const SizedBox(width: Spacing.md),
            Flexible(
              child: Text(
                locale.meal_details_select_meal_button,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
