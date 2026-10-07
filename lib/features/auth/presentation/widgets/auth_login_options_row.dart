import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthLoginOptionsRow extends StatelessWidget {
  const AuthLoginOptionsRow({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            locale.forgot_password,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.primary,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) => onRememberMeChanged(value ?? false),
              activeColor: color.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusXs),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            GestureDetector(
              onTap: () => onRememberMeChanged(!rememberMe),
              child: Text(
                locale.remember_me,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
