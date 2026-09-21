import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.labelText ?? l10n.password,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppTextField(
          isGlass: true,
          controller: widget.controller,
          hint: widget.hintText ?? l10n.password_hint,
          obscureText: _obscureText,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColors.primary,
            size: 23,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.greyLight,
              size: 22,
            ),
          ),
          validator:
              widget.validator ??
              (value) => Validations.validatePassword(context, value),
        ),
      ],
    );
  }
}
