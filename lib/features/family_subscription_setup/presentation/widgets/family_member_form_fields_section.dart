import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_gender_option.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_phone_field.dart';

class FamilyMemberFormFieldsSection extends StatelessWidget {
  const FamilyMemberFormFieldsSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.gender,
    required this.isPhoneEnabled,
    required this.nameError,
    required this.phoneError,
    required this.ageError,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onPhoneLookup,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.relationshipChild,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final int gender;
  final bool isPhoneEnabled;
  final String? nameError;
  final String? phoneError;
  final String? ageError;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String?> onPhoneChanged;
  final ValueChanged<String> onPhoneLookup;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<int> onGenderChanged;
  final Widget relationshipChild;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_phone_number,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        BlocSelector<FamilySubscriptionSetupViewModel, FamilyPlanState, bool>(
          selector: (state) => state.isMemberLookupLoading,
          builder: (context, isLoading) => FamilyMemberPhoneField(
            controller: phoneController,
            enabled: isPhoneEnabled,
            isLoading: isLoading,
            errorText: phoneError,
            onPhoneChanged: onPhoneChanged,
            onLookup: onPhoneLookup,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Text(
          locale.family_full_name,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        AppTextField(
          controller: nameController,
          hint: locale.family_full_name_hint,
          errorText: nameError,
          onChanged: onNameChanged,
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: color.onSurfaceVariant,
            size: Spacing.iconSm,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: relationshipChild),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.family_age,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  AppTextField(
                    controller: ageController,
                    hint: locale.family_age_hint,
                    errorText: ageError,
                    onChanged: onAgeChanged,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconSm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Text(
          locale.family_gender,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            Expanded(
              child: FamilyGenderOption(
                label: locale.family_gender_male,
                isSelected: gender == 1,
                onTap: () => onGenderChanged(1),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: FamilyGenderOption(
                label: locale.family_gender_female,
                isSelected: gender == 2,
                onTap: () => onGenderChanged(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}
