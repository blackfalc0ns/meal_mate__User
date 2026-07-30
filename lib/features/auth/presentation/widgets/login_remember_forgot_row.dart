import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class LoginRememberForgotRow extends StatefulWidget {
  const LoginRememberForgotRow({super.key, this.onForgotPassword});

  final VoidCallback? onForgotPassword;

  @override
  State<LoginRememberForgotRow> createState() => _LoginRememberForgotRowState();
}

class _LoginRememberForgotRowState extends State<LoginRememberForgotRow> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Forgot Password

        // Remember Me
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: Spacing.xs),

            Text(
              l10n.remember_me,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: widget.onForgotPassword,
          child: Text(
            l10n.forgot_password,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
