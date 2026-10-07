import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
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
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.labelText ?? locale.password,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppTextField(
          isGlass: true,
          controller: widget.controller,
          hint: widget.hintText ?? locale.password_hint,
          obscureText: _obscureText,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: color.primary,
            size: Spacing.iconMd,
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
              color: color.onSurfaceVariant,
              size: Spacing.iconMd,
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

