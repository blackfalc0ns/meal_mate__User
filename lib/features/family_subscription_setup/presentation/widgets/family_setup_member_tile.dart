import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilySetupMemberTile extends StatelessWidget {
  const FamilySetupMemberTile({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  final FamilyMemberEntity member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.primary.withValues(alpha: 0.1),
            child: Icon(
              member.gender == 2 ? Icons.person : Icons.person_outline,
              color: color.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (member.isManager) ...[
                      const SizedBox(width: Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xss,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                        ),
                        child: Text(
                          locale.family_owner,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ],
                    if (member.isUnsubscribed && !member.isManager) ...[
                      const SizedBox(width: Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xss,
                        ),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                        ),
                        child: Text(
                          locale.family_member_unsubscribed_status,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!member.isManager) ...[
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: color.onSurfaceVariant,
                size: 18,
              ),
              onPressed: onEdit,
            ),
            if (member.canDeleteFromSetupFlow)
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: color.error,
                  size: 18,
                ),
                onPressed: onDelete,
              ),
          ],
        ],
      ),
    );
  }
}
