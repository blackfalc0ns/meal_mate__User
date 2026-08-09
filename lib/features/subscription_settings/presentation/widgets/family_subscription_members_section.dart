import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_member_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_section_header.dart';

class FamilySubscriptionMembersSection extends StatelessWidget {
  const FamilySubscriptionMembersSection({super.key, required this.members});

  final List<FamilySubscriptionMemberEntity> members;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface.withValues(alpha: 0),
      child: Column(
        children: [
          FamilySubscriptionSectionHeader(
            title: locale.family_manage_family_members,
            actionLabel: locale.family_manage_show_all,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              for (int index = 0; index < members.length; index++) ...[
                if (index > 0) const SizedBox(width: 11.58),
                Expanded(
                  child: FamilySubscriptionMemberCard(member: members[index]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
