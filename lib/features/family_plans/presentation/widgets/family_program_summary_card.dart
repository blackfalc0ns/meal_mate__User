import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_metric.dart';

class FamilyProgramSummaryCard extends StatelessWidget {
  const FamilyProgramSummaryCard({super.key, required this.member});

  final FamilyProgramSetupMemberDetailsFakeData member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyProgramSummaryHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.30),
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.familyProgramSummaryRadius),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              member.imageAsset,
              width: Spacing.familyProgramSummaryAvatarSize,
              height: Spacing.familyProgramSummaryAvatarSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      member.age,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Container(
                      width: Spacing.xss,
                      height: Spacing.xss,
                      decoration: BoxDecoration(
                        color: color.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Text(
                      member.gender,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          FamilyProgramSummaryMetric(
            value: member.goal,
            label: locale.family_selected_member_goal_label,
            icon: Icons.balance_rounded,
          ),
          const SizedBox(width: Spacing.sm),
          SizedBox(
            height: Spacing.familyProgramSummaryDividerHeight,
            child: VerticalDivider(color: color.outlineVariant),
          ),
          const SizedBox(width: Spacing.sm),
          FamilyProgramSummaryMetric(
            value: member.activityLevel,
            label: locale.family_activity_level,
            icon: Icons.directions_run_rounded,
          ),
        ],
      ),
    );
  }
}
