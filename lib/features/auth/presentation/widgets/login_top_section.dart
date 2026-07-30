import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class LoginTopSection extends StatelessWidget {
  const LoginTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.35,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xl,
          vertical: Spacing.base,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome text
            Text(
              l10n.welcome_back,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size28,
                color: AppColors.black,
              ),
            ),
            // MealMate - each word separate style
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Meal',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size40,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  TextSpan(
                    text: 'Mate',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size40,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'سجل دخولك للوصول الى خطتك',
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: AppColors.black,
              ),
            ),
            Text(
              'الغذائية ومتابعة أهدافك الصحية',
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
