import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class PersonalInformationFormCard extends StatelessWidget {
  const PersonalInformationFormCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    this.onSubmitted,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.lg,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xxs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: nameController,
            label: locale.auth_name_label,
            hint: locale.auth_name_hint,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: color.primary,
              size: Spacing.iconMd,
            ),
            validator: (value) => Validations.validateName(context, value),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            borderRadius: Spacing.inputRadius,
            borderColor: color.outlineVariant,
            fillColor: color.surface,
            textStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
            labelStyle: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.base),
          AppTextField(
            controller: phoneController,
            label: locale.phone_number,
            hint: locale.phone_hint,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(
              Icons.local_phone_outlined,
              color: color.primary,
              size: Spacing.iconMd,
            ),
            validator: (value) =>
                Validations.validatePhoneNumber(context, value),
            onSubmitted: onSubmitted,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            borderRadius: Spacing.inputRadius,
            borderColor: color.outlineVariant,
            fillColor: color.surface,
            textStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
            labelStyle: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
