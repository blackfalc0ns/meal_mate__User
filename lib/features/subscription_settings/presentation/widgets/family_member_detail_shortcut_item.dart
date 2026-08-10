import 'package:flutter/material.dart';
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

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: Spacing.familyMemberDetailShortcutIconSize,
            color: color.primary,
          ),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortcut.title,
                 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  shortcut.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
