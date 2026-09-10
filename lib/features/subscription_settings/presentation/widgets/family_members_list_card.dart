import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
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

    final statusColor = member.isPaused
        ? color.error
        : member.setupStatus == 3
        ? color.primary
        : color.secondary;

    final statusLabel = member.isPaused
        ? locale.family_member_paused_label
        : member.setupStatus == 3
        ? locale.family_manage_active
        : locale.family_member_in_progress;

    final IconData programIcon = switch (member.programName.toLowerCase()) {
      final p when p.contains('متوازن') || p.contains('balance') =>
        Icons.balance,
      final p when p.contains('عضلات') || p.contains('muscle') =>
        Icons.fitness_center,
      final p when p.contains('وزن') || p.contains('weight') =>
        Icons.trending_down,
      _ => Icons.restaurant_menu,
    };

    final String noteText;
    final Color noteColor;
    if (member.todayUiStatus != null && member.todayUiStatus!.isNotEmpty) {
      noteText = member.todayUiStatus!;
      noteColor = member.isManager ? color.primary : color.secondary;
    } else if (member.isManager) {
      noteText = locale.family_member_all_meals_manager;
      noteColor = color.primary;
    } else if (member.setupStatus == 0) {
      noteText = locale.family_member_no_plan_selected;
      noteColor = color.error;
    } else {
      noteText = locale.family_member_some_meals_customized;
      noteColor = color.secondary;
    }

    final mealsDaysText =
        '${member.todayRequiredCount > 0 ? member.todayRequiredCount : 4} ${locale.family_manage_meals.replaceFirst('ال', '')} • ${member.remainingDays > 0 ? member.remainingDays : 7} ${locale.family_days_7.replaceAll(RegExp(r'[0-9]'), '').trim()}';

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
          child: Row(mainAxisAlignment: MainAxisAlignment.start,  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [  Icon(
                          Icons.chevron_right_rounded,
                          size: Spacing.iconSm,
                          color: color.onSurfaceVariant,
                        ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          programIcon,
                          size: Spacing.familyMembersGoalIconSize,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.hasPlan
                              ? member.programName
                              : locale.family_member_no_plan,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mealsDaysText,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: Spacing.iconSm,
                          color: color.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Container(
                      height: Spacing.familyMembersStatusChipHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Spacing.radiusPill,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            statusLabel,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size9,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Container(
                      height: Spacing.familyMembersNoteChipHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: noteColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Spacing.radiusPill,
                        ),
                      ),
                      child: Center(
                        widthFactor: 1.0,
                        child: Text(
                          noteText,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: noteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      Assets.profileAvatar,
                      width: Spacing.familyMembersAvatarSize,
                      height: Spacing.familyMembersAvatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    height: Spacing.familyMembersAccountChipHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(
                        Spacing.radiusPill,
                      ),
                    ),
                    child: Center(
                      widthFactor: 1.0,
                      child: Text(
                        locale.family_member_has_account,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size8,
                          color: color.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
