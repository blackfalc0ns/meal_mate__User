import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class AuthLoginOptionsRow extends StatefulWidget {
  const AuthLoginOptionsRow({
    super.key,
    required this.onForgotPassword,
  });

  final VoidCallback onForgotPassword;

  @override
  State<AuthLoginOptionsRow> createState() => _AuthLoginOptionsRowState();
}

class _AuthLoginOptionsRowState extends State<AuthLoginOptionsRow> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: widget.onForgotPassword,
          child: Text(
            l10n.forgot_password,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              l10n.remember_me,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
