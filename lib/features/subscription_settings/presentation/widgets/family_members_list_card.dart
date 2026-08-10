import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMembersListCard extends StatelessWidget {
  const FamilyMembersListCard({super.key, required this.member, this.onTap});

  final FamilySubscriptionListMemberEntity member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final statusColor =
        member.status == FamilySubscriptionListMemberStatus.active
        ? color.primary
        : color.secondary;
    final noteColor = switch (member.noteStatus) {
      FamilySubscriptionListMemberNoteStatus.success => color.primary,
      FamilySubscriptionListMemberNoteStatus.warning => color.secondary,
      FamilySubscriptionListMemberNoteStatus.error => color.error,
    };

    return Material(
      color: color.surface,
      borderRadius: BorderRadius.circular(Spacing.familyMembersCardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.familyMembersCardRadius),
        child: Container(
          height: Spacing.familyMembersCardHeight,
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
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                offset: const Offset(Spacing.zero, Spacing.xss),
                blurRadius: Spacing.xss,
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      member.imageAsset,
                      width: Spacing.familyMembersAvatarSize,
                      height: Spacing.familyMembersAvatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    height: Spacing.familyMembersAccountChipHeight,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    decoration: BoxDecoration(
                      color: color.primaryContainer.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                    child: Center(
                      child: Text(
                        member.accountLabel,
                        locale: Locale(locale.localeName),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size9,
                          color: color.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      locale: Locale(locale.localeName),
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _goalIcon,
                          size: Spacing.familyMembersGoalIconSize,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.programLabel,
                          locale: Locale(locale.localeName),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          member.daysLabel,

                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: Spacing.xs,
                            color: color.primary,
                          ),
                        ),
                        Text(
                          member.mealsLabel,
                          locale: Locale(locale.localeName),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: Spacing.familyMembersStatusChipHeight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
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
                              Icon(
                                Icons.circle,
                                size: Spacing.xs,
                                color: statusColor,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Text(
                                member.statusLabel,
                                locale: Locale(locale.localeName),
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: statusColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Flexible(
                          child: Container(
                            height: Spacing.familyMembersNoteChipHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: noteColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusPill,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                member.noteLabel,
                                locale: Locale(locale.localeName),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size9,
                                  color: noteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.lg),

              const SizedBox(width: Spacing.md),

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

  IconData get _goalIcon {
    return switch (member.goal) {
      FamilySubscriptionListMemberGoal.balanced => Icons.balance_rounded,
      FamilySubscriptionListMemberGoal.weightLoss =>
        Icons.trending_down_rounded,
      FamilySubscriptionListMemberGoal.muscleGain =>
        Icons.fitness_center_rounded,
    };
  }
}
