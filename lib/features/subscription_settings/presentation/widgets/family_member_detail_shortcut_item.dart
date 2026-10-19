import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberDetailShortcutItem extends StatelessWidget {
  const FamilyMemberDetailShortcutItem({super.key, required this.shortcut});

  final FamilyMemberDetailShortcutEntity shortcut;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final icon = shortcut.type == FamilyMemberDetailShortcutType.dailyMeals
        ? Icons.calendar_month_rounded
        : Icons.manage_accounts_rounded;
    final onTap =
        shortcut.onTap ??
        switch (shortcut.type) {
          FamilyMemberDetailShortcutType.dailyMeals => () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.familyMemberDailyMeals),
          FamilyMemberDetailShortcutType.permissions => () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.familyMemberAccess),
        };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.familyMemberDetailCardRadius),
      child: Container(
        height: Spacing.familyMemberDetailShortcutHeight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(
            Spacing.familyMemberDetailCardRadius,
          ),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.5),
            width: Spacing.familyMemberDetailCardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Spacing.familyMemberDetailShortcutIconSize,
              color: color.primary,
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shortcut.title,
                    locale: Locale(locale.localeName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    shortcut.subtitle,
                    locale: Locale(locale.localeName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              size: Spacing.iconSm,
              color: color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
