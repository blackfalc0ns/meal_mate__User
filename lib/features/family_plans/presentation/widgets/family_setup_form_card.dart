import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_activity_selector.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_field.dart';

class FamilySetupFormCard extends StatelessWidget {
  const FamilySetupFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.familySetupFormCardRadius),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FamilySetupField(
            label: locale.family_full_name,
            hint: locale.family_full_name_hint,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: Spacing.familySetupFormFieldGap),
          FamilySetupField(
            label: locale.family_location,
            hint: locale.family_location_hint,
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: Spacing.familySetupFormFieldGap),
          Row(
            children: [
              Expanded(
                child: FamilySetupField(
                  label: locale.family_relation,
                  hint: locale.family_relation_hint,
                  icon: Icons.person_rounded,
                  trailing: Icons.keyboard_arrow_down_rounded,
                ),
              ),
              const SizedBox(width: Spacing.familySetupTwoColumnGap),
              Expanded(
                child: FamilySetupField(
                  label: locale.family_age,
                  hint: locale.family_age_hint,
                  icon: Icons.calendar_month_outlined,
                  suffix: locale.family_year,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.familySetupFormFieldGap),
          FamilySetupField(
            label: locale.family_nutrition_goal,
            hint: locale.family_nutrition_goal_hint,
            icon: Icons.track_changes_rounded,
            trailing: Icons.keyboard_arrow_down_rounded,
          ),
          const SizedBox(height: Spacing.familySetupFormFieldGap),
          const FamilySetupActivitySelector(),
        ],
      ),
    );
  }
}
