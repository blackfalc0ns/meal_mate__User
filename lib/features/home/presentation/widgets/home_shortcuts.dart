import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeShortcuts extends StatelessWidget {
  const HomeShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final entries = [
      (Assets.homeShortcutCalendar, locale.home_shortcut_my_meals),
      (Assets.homeShortcutAward, locale.home_shortcut_subscription),
      (Assets.homeShortcutLeaf, locale.home_shortcut_allergy),
      (Assets.homeShortcutGift, locale.home_shortcut_offers),
    ];
    return SizedBox(
      height: Spacing.homeShortcutHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: entries.map((entry) {
          return Container(
            width: Spacing.homeShortcutCardWidth,
            height: Spacing.homeShortcutHeight,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.homeShortcutRadius),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.homeShortcutBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.10),
                  blurRadius: Spacing.xs,
                  offset: const Offset(0, Spacing.xs),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  entry.$1,
                  width: Spacing.homeShortcutIconSize,
                  height: Spacing.homeShortcutIconSize,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  entry.$2,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: 11.303,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
