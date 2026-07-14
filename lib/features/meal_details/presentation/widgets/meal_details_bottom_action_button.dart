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
          textDirection: TextDirection.rtl,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    locale.meal_details_select_meal_button,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size16,
                      color: color.onPrimary,
                    ).copyWith(height: locale.localeName == 'ar' ? 1.25 : 1.1),
                  ),
                  Text(
                    locale.meal_details_select_meal_hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size9,
                      color: color.onPrimary,
                    ).copyWith(height: locale.localeName == 'ar' ? 1.35 : 1.1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.onPrimary,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.sm),
                child: Icon(
                  Icons.check_rounded,
                  size: Spacing.iconMd,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
