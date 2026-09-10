import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

class FamilyMembersListCard extends StatelessWidget {
  const FamilyMembersListCard({super.key, required this.member, this.onTap});
  final FamilyMemberSummaryEntity member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final statusColor = member.isPaused ? color.error : color.primary;
    final age = member.ageYears;
    return Material(
      color: color.surface,
      borderRadius: BorderRadius.circular(Spacing.familyMembersCardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.familyMembersCardRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familyMembersCardHorizontalPadding,
            vertical: Spacing.familyMembersCardVerticalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Spacing.familyMembersCardRadius,
            ),
            border: Border.all(
              color: color.outlineVariant,
              width: Spacing.familyMembersCardBorder,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: Spacing.familyMembersAvatarSize / 2,
                backgroundColor: color.primaryContainer,
                child: Icon(Icons.person_outline_rounded, color: color.primary),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                    if (age != null) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_member_age_years(age),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: Spacing.xs),
                    Text(
                      member.hasPlan
                          ? member.programName
                          : locale.family_member_no_plan,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    if (member.hasPlan) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_member_days_remaining(
                          member.remainingDays,
                        ),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: Spacing.xs),
                    Text(
                      member.isPaused
                          ? locale.family_member_paused_label
                          : locale.family_member_active_label,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: Spacing.iconMd,
                color: color.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
