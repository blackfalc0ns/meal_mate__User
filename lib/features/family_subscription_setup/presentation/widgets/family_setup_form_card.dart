import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_gender_option.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_field.dart';

class FamilySetupFormCard extends StatelessWidget {
  const FamilySetupFormCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.relationshipText,
    required this.onRelationshipTap,
    this.gender,
    required this.onGenderChanged,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final String relationshipText;
  final VoidCallback onRelationshipTap;
  final int? gender;
  final ValueChanged<int> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(Spacing.familySetupFormCardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
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
            controller: nameController,
          ),
          const SizedBox(height: Spacing.md),
          FamilySetupField(
            label: locale.family_phone_number,
            hint: locale.family_phone_number_hint,
            icon: Icons.phone_outlined,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FamilySetupField(
                  label: locale.family_relation,
                  hint: relationshipText.isNotEmpty
                      ? relationshipText
                      : locale.family_relation_hint,
                  icon: Icons.person_rounded,
                  trailing: Icons.keyboard_arrow_down_rounded,
                  readOnly: true,
                  onTap: onRelationshipTap,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: FamilySetupField(
                  label: locale.family_age,
                  hint: locale.family_age_hint,
                  icon: Icons.calendar_month_outlined,
                  suffix: locale.family_year,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wc_rounded, size: Spacing.iconSm, color: color.primary),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.family_gender,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xss),
          Row(
            children: [
              Expanded(
                child: FamilyGenderOption(
                  label: locale.family_gender_male,
                  isSelected: gender == 1,
                  onTap: () => onGenderChanged(1),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: FamilyGenderOption(
                  label: locale.family_gender_female,
                  isSelected: gender == 2,
                  onTap: () => onGenderChanged(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
