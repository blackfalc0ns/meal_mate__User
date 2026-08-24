import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_add_member_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_member_card.dart';

class FamilySetupMemberData {
  const FamilySetupMemberData({required this.name, required this.imageAsset});

  final String name;
  final String imageAsset;
}

class FamilySetupMembersRow extends StatelessWidget {
  const FamilySetupMembersRow({super.key, required this.members});

  final List<FamilySetupMemberData> members;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: Row(
        children: [
          for (final member in members)
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.xss),
                child: FamilySetupMemberCard(
                  name: member.name,
                  imageAsset: member.imageAsset,
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.xss),
              child: FamilySetupAddMemberCard(
                label: locale.family_add_member_button,
              ),
            ),
          ),
          Expanded(
            child: FamilySetupAddMemberCard(
              label: locale.family_add_member_button,
            ),
          ),
        ],
      ),
    );
  }
}
