import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_shortcut_item.dart';

class FamilyMemberDetailShortcutBar extends StatelessWidget {
  const FamilyMemberDetailShortcutBar({super.key, required this.shortcuts});

  final List<FamilyMemberDetailShortcutEntity> shortcuts;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyMemberDetailShortcutHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.familyMemberDetailCardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chevron_left_rounded,
            size: Spacing.iconMd,
            color: color.primary,
            semanticLabel: locale.localeName,
          ),
          for (int index = 0; index < shortcuts.length; index++) ...[
            FamilyMemberDetailShortcutItem(shortcut: shortcuts[index]),
            if (index == 0)
              SizedBox(
                height: Spacing.familyMemberDetailShortcutDividerHeight,
                child: VerticalDivider(
                  color: color.outlineVariant,
                  thickness: Spacing.hairline,
                ),
              ),
          ],
          Icon(
            Icons.chevron_right_rounded,
            size: Spacing.iconMd,
            color: color.primary,
          ),
        ],
      ),
    );
  }
}
