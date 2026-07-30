import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/country_code_prefix.dart';

class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            l10n.phone_number,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppTextField(
          isGlass: true,
          controller: controller,
          hint: hintText ?? l10n.phone_hint,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.local_phone_outlined,
            color: AppColors.primary,
            size: 23,
          ),
          suffixIcon: const CountryCodePrefix(),
          // validator:
          //     validator ??
          //     (value) => Validations.validatePhoneNumber(context, value),
        ),
      ],
    );
  }
}
