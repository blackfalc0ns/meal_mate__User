import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class SignUpRow extends StatelessWidget {
  const SignUpRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dont_have_account,
          style: getRegularStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to sign up
          },
          child: Text(
            l10n.sign_up,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
