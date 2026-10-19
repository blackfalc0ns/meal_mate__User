import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_shortcut_item.dart';

class FamilyMemberDetailShortcutBar extends StatelessWidget {
  const FamilyMemberDetailShortcutBar({super.key, required this.shortcuts});

  final List<FamilyMemberDetailShortcutEntity> shortcuts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < shortcuts.length; index++) ...[
          if (index > 0) const SizedBox(width: Spacing.sm),
          Expanded(
            child: FamilyMemberDetailShortcutItem(shortcut: shortcuts[index]),
          ),
        ],
      ],
    );
  }
}
